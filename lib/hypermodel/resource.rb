require 'hypermodel/serializers/mongoid'

module Hypermodel
  # Public: Responsible for building the response in JSON-HAL format. It is
  # meant to be used by Hypermodel::Responder.
  #
  # In future versions one will be able to subclass it and personalize a
  # Resource for each diffent model, i.e. creating a PostResource.
  class Resource
    extend Forwardable

    def_delegators :@serializer, :attributes, :record, :resources,
                                 :sub_resources, :embedded_resources

    # Public: Initializes a Resource.
    #
    # record     - A Mongoid instance of a model.
    # controller - An ActionController instance.
    #
    # TODO: Detect record type (ActiveRecord, DataMapper, Mongoid, etc..) and
    # choose the corresponding serializer.
    def initialize(record, controller)
      @serializer = Serializers::Mongoid.new(record)
      @controller = controller
    end

    # Public: Returns a Hash of the resource in JSON-HAL.
    #
    # opts - Options to pass to the resource to_json.
    def to_json(*opts)
      attributes.update(links).update(embedded).to_json(*opts)
    end

    # Internal: Constructs the _links section of the response.
    #
    # Returns a Hash of the links of the resource. It will include, at least,
    # a link to itself.
    def links
      _links = { self: polymorphic_url(record) }

      resources.each do |name, resource|
        _links.update(name => polymorphic_url(resource))
      end

      sub_resources.each do |sub_resource|
        _links.update(sub_resource => polymorphic_url([record, sub_resource]))
      end

      { _links: _links }
    end

    # Internal: Constructs the _embedded section of the response.
    #
    # Returns a Hash of the embedded resources of the resource.
    def embedded
      { _embedded: embedded_resources }
    end

    # Internal: Returns the url wrapped in a Hash in HAL format.
    def polymorphic_url(record_or_hash_or_array, options = {})
      { href: @controller.polymorphic_url(record_or_hash_or_array, options = {}) }
    end
  end
end
