# This class is ORM agnostic. Wohoo!
# Next step is to select which fields to include in the output.
class Resource
  def initialize(serializer, controller)
    @serializer = serializer
    @controller = controller
  end

  def to_json(*opts)
    @serializer.attributes.update(links).update(embedded).to_json(*opts)
  end

  def links
    hash = { self: { href: @controller.polymorphic_url(@serializer.resource) } }
    @serializer.resources.each do |name, resource|
      hash.update(name => {href: @controller.polymorphic_url(resource)})
    end

    @serializer.sub_resources.each do |sub_resource|
      hash.update(sub_resource => {href: @controller.polymorphic_url([@serializer.resource, sub_resource])})
    end

    { _links: hash }
  end

  def embedded
    @serializer.embedded_resources
  end
end
