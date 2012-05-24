require 'hypermodel/resource'
require 'hypermodel/collection'

module Hypermodel
  # Public: Responsible for exposing a resource in JSON-HAL format.
  #
  # Examples
  #
  # class PostsController < ApplicationController
  #   respond_to :json
  #
  #   def show
  #     @post = Post.find params[:id]
  #     respond_with(@post, responder: Hypermodel::Responder)
  #   end
  # end
  class Responder
    def self.call(*args)
      controller    = args[0]
      resource      = args[1].first
      resource_name = controller.params["controller"]
      action        = controller.params["action"]

      responder = new resource_name, action, resource, controller

      controller.render json: responder
    end

    def initialize(resource_name, action, record, controller)
      @resource_name = resource_name
      @action        = action
      @resource      = if record.respond_to?(:each)
                         Collection.new(record, controller)
                       else
                         Resource.new(record, controller)
                       end
    end

    def to_json(*opts)
      @resource.to_json(*opts)
    end
  end
end

