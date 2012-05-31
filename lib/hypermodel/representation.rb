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

    def self.link(name)
      @@links << name
      @@links
    end

    def self.embed(name)
      @@embeds << name
      @@embeds
    end

    def self.attributes(*attributes)
      @@selected_attributes = attributes
    end

    def links
      @@links.inject({self: context.polymorphic_url(record)}) do |links, name|
        links.update(name => context.polymorphic_url(record.send(name)))
      end
    end

    def embedded
      @@embeds.inject({}) do |embedded, name|
        embedded.update(name => record.send(name))
      end
    end

    def attributes
      record.attributes.select do |attribute, value|
        @@selected_attributes.include? attribute
      end
    end
  end
end
