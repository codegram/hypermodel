module Hypermodel
  class Representation
    attr_accessor :record, :context
    @@links = []
    @@embeds = []
    @@selected_attributes = []

    def initialize(record, context)
      @record = record
      @context = context
    end

    def self.link(name, &block)
      @@links << [name, block]
      @@links
    end

    def self.embed(name, &block)
      @@embeds << [name, block]
      @@embeds
    end

    def self.attributes(*attributes)
      @@selected_attributes = attributes
    end

    def links
      @@links.inject({self: context.polymorphic_url(record)}) do |links, (name, block)|
        value = if block
          block.call(record, context)
        else
          context.polymorphic_url(record.send(name))
        end
        links.update(name => value)
      end
    end

    def embedded
      @@embeds.inject({}) do |embedded, (name, block)|
        value = if block
          block.call(record, context)
        else
          record.send(name)
        end
        embedded.update(name => value)
      end
    end

    def attributes
      record.attributes.select do |attribute, value|
        @@selected_attributes.include? attribute
      end
    end
  end
end
