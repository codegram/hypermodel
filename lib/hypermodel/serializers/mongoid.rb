module Hypermodel
  module Serializers
    class Mongoid
      attr_reader :record, :attributes
      def initialize(record)
        @record   = record
        @attributes = record.attributes.dup
      end

      def resources
        relations = select_relations_by_type(::Mongoid::Relations::Referenced::In)

        relations.inject({}) do |acc, (name, _)|
          acc.update(name => @record.send(name))
        end
      end

      def sub_resources
        select_relations_by_type(::Mongoid::Relations::Referenced::Many).keys
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
      def select_relations_by_type(type)
        referenced_relations.select do |name, metadata|
          metadata.relation == type
        end
      end

      def extract_embedded_attributes(name, metadata)
        relation = metadata.relation

        if relation == ::Mongoid::Relations::Embedded::Many
          @record.send(name).map { |embedded| embedded.attributes }
        elsif relation == ::Mongoid::Relations::Embedded::One
          (embedded = @record.send(name)) ? embedded.attributes : nil
        else
          raise "Embedded relation type not implemented: #{relation}"
        end
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
