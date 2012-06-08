module Hypermodel
  class Representation
    @@links = []
    @@embeds = []
    @@selected_attributes = []

    def initialize(record, context)
      @record = record
      @context = context
    end

    def self.link(name, options = {}, &block)
      @@links << [name, options, block]
    end

    def self.embed(name, options = {}, &block)
      @@embeds << [name, options, block]
    end

    def self.attributes(*attributes)
      @@selected_attributes = attributes
    end

    def links
      @links ||= LinkBuilder.new(@record, @context, @@links).links
    end

    def embedded
      @embeds ||= EmbedBuilder.new(@record, @context, @@embeds).embedded
    end

    def attributes
      @attributes ||= AttributeBuilder.new(@record.attributes, @@selected_attributes).attributes
    end
  end
end

require_relative 'link_builder'
require_relative 'embed_builder'
require_relative 'attribute_builder'
