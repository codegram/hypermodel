require 'hypermodel/serializers/mongoid'
# This class is ORM agnostic. Wohoo!
# Next step is to select which fields to include in the output.
module Hypermodel
  class Resource
    # TODO: Detect resource type (AR, DM, Mongoid, etc..) and create the
    # corresponding serializer.
    def initialize(record, controller)
      @serializer = Serializers::Mongoid.new(record)
      @controller = controller
    end

    def to_json(*opts)
      @serializer.attributes.update(links).update(embedded).to_json(*opts)
    end

    def links
      hash = { self: { href: @controller.polymorphic_url(@serializer.record) } }
      @serializer.resources.each do |name, resource|
        hash.update(name => {href: @controller.polymorphic_url(resource)})
      end

      @serializer.sub_resources.each do |sub_resource|
        hash.update(sub_resource => {href: @controller.polymorphic_url([@serializer.record, sub_resource])})
      end

      { _links: hash }
    end

    def embedded
      @serializer.embedded_resources
    end
  end
end
