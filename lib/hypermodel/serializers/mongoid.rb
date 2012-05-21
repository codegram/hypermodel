module Hypermodel
  module Serializers
    # Internal: A Mongoid serializer that complies with the Hypermodel
    # Serializer API.
    #
    # It is used by Hypermodel::Resource to extract the attributes and
    # resources of a given record.
    class Mongoid

      # Public: Returns the Mongoid instance
      attr_reader :record

      # Public: Returns the attributes of the Mongoid instance
      attr_reader :attributes

      # Public: Initializes a Serializer::Mongoid.
      #
      # record - A Mongoid instance of a model.
      def initialize(record)
        @record     = record
        @attributes = record.attributes.dup
      end

      # Public: Returns a Hash with the resources that are linked to the
      # record. It will be used by Hypermodel::Resource.
      #
      # An example of a linked resource could be the author of a post. Think
      # of `/authors/:author_id`
      #
      # The format of the returned Hash must be the following:
      #
      #   {resource_name: resource_instance}
      #
      # `resource_name` can be either a Symbol or a String.
      def resources
        relations = select_relations_by_type(::Mongoid::Relations::Referenced::In)

        relations.inject({}) do |acc, (name, _)|
          acc.update(name => @record.send(name))
        end
      end

      # Public: Returns a Hash with the sub resources that are linked to the
      # record. It will be used by Hypermodel::Resource. These resources need
      # to be differentiated so Hypermodel::Resource can build the url.
      #
      # An example of a linked sub resource could be comments of a post.
      # Think of `/posts/:id/comments`
      #
      # The format of the returned Hash must be the following:
      #
      #   {:sub_resource, :another_subresource}
      def sub_resources
        select_relations_by_type(::Mongoid::Relations::Referenced::Many).keys
      end

      # Public: Returns a Hash with the embedded resources attributes. It will
      # be used by Hypermodel::Resource.
      #
      # An example of an embedded resource could be the reviews of a post, or
      # the addresses of a company. But you can really embed whatever you like.
      #
      # An example of the returning Hash could be the following:
      #
      #   {"comments"=>
      #     [
      #       {"_id"=>"4fb941cb82b4d46162000007", "body"=>"Comment 1"},
      #       {"_id"=>"4fb941cb82b4d46162000008", "body"=>"Comment 2"}
      #     ]
      #   }
      def embedded_resources
        return {} if embedded_relations.empty?

        embedded_relations.inject({}) do |acc, (name, metadata)|
          if attributes = extract_embedded_attributes(name)
            @attributes.delete(name)
            acc.update(name => attributes)
          end
          acc
        end
      end

      #######
      private
      #######

      def select_relations_by_type(type)
        referenced_relations.select do |name, metadata|
          metadata.relation == type
        end
      end

      def extract_embedded_attributes(name)
        embedded = @record.send(name)

        return {} unless embedded
        return embedded.map(&:attributes) if embedded.respond_to?(:map)

        embedded.attributes
      end

      def embedded_relations
        @embedded_relations ||= @record.relations.select do |_, metadata|
          metadata.relation.name =~ /Embedded/
        end
      end

      def referenced_relations
        @referenced_relations ||= @record.relations.select do  |_, metadata|
          metadata.relation.name =~ /Referenced/
        end
      end
    end
  end
end
