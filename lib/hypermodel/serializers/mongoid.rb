module Hypermodel
  module Serializers
    class Mongoid
      attr_reader :resource, :attributes
      def initialize(resource)
        @resource   = resource
        @attributes = resource.attributes.dup
      end

      def resources
        links = referenced_relations.select do |name, metadata|
          metadata.relation == ::Mongoid::Relations::Referenced::In
        end

        links.inject({}) do |acc, (name, metadata)|
          acc.update(name => @resource.send(name))
        end
      end

      def sub_resources
        links = referenced_relations.select do |name, metadata|
          metadata.relation == ::Mongoid::Relations::Referenced::Many
        end

        links.keys
      end

      def embedded_resources
        return {} if embedded_relations.empty?

        embedded_relations.inject({ _embedded: {} }) do |acc, (name, metadata)|
          if attributes = extract_embedded_attributes(name, metadata)
            @attributes.delete(name)
            acc[:_embedded][name] = attributes
          end
          acc
        end
      end

      private
      def extract_embedded_attributes(name, metadata)
        relation = metadata.relation

        if relation == ::Mongoid::Relations::Embedded::Many
          @resource.send(name).map { |embedded| embedded.attributes }
        elsif relation == ::Mongoid::Relations::Embedded::One
          (embedded = resource.send(name)) ? embedded.attributes : nil
        else
          raise "Embedded relation type not implemented: #{relation}"
        end
      end

      def embedded_relations
        @embedded_relations ||= @resource.relations.select do |_, metadata|
          metadata.relation.name =~ /Embedded/
        end
      end

      def referenced_relations
        @referenced_relations ||= @resource.relations.select do  |_, metadata|
          metadata.relation.name =~ /Referenced/
        end
      end
    end
  end
end
