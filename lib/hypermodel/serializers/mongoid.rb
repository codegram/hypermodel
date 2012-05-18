module Hypermodel
  module Serializers
    class Mongoid
      def initialize(resource, controller)
        @resource   = resource
        @attributes = resource.attributes.dup
        @controller = controller
      end

      def to_json(*opts)
        attrs = @attributes.update(links).update(embedded)
        attrs.to_json(*opts)
      end

      def links
        hash = { self: { href: @controller.polymorphic_url(@resource) } }

        referenced_relations.each do |name, metadata|
          related = @resource.send(name)
          relation = metadata.relation

          if relation == ::Mongoid::Relations::Referenced::In
            unless related.nil? || (related.respond_to?(:empty?) && related.empty?)
              hash.update(name => { href: @controller.polymorphic_url(related) })
            end
          elsif relation == ::Mongoid::Relations::Referenced::Many
            hash.update(name => { href: @controller.polymorphic_url([@resource, name]) })
          else
            raise "Referenced relation type not implemented: #{relation}"
          end

        end

        { _links: hash }
      end

      def embedded
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
