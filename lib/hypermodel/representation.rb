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

    def self.link(name, options = {}, &block)
      @@links << [name, options, block]
      @@links
    end

    def self.embed(name, options = {}, &block)
      @@embeds << [name, options, block]
      @@embeds
    end

    def self.attributes(*attributes)
      @@selected_attributes = attributes
    end

    def links
      @@links.inject({self: context.polymorphic_url(record)}) do |links, (name, options, block)|
        next links if should_skip(options)

        link = if block
          block.call(record, context)
        else
          context.polymorphic_url(record.send(name))
        end

        links.update(name => link)
      end
    end

    def embedded
      @@embeds.inject({}) do |embedded, (name, options, block)|
        next embedded if should_skip(options)

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

    private
    def should_skip(options)
      return false unless options.include? :if
      return false if options[:if] == nil

      !options[:if].call(record, context)
    end
  end
end
