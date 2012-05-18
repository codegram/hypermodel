require 'hypermodel/serializers/mongoid'

module Hypermodel
  Serializer = Serializers::Mongoid

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
      @resource      = Serializer.new(resource, controller)
    end

    def to_json(*opts)
      @resource.to_json(*opts)
    end
  end
end

