require 'hypermodel/serializers/mongoid'
require 'hypermodel/resource'

module Hypermodel
  class Responder
    def self.call(*args)
      controller    = args[0]
      resource      = args[1].first
      resource_name = controller.params["controller"]
      action        = controller.params["action"]

      responder = new resource_name, action, resource, controller

      controller.render json: responder
    end

    def initialize(resource_name, action, resource, controller)
      @resource_name = resource_name
      @action        = action
      @serializer    = Serializers::Mongoid.new(resource)
      @resource      = Resource.new(@serializer, controller)
    end

    def to_json(*opts)
      @resource.to_json(*opts)
    end
  end
end

