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

      representation = new(resource, controller)

      controller.render json: representation
    end

    def initialize(record, controller)
      @representation = Representation.new(record, controller)
    end

    def to_json(*opts)
      @representation.to_json(*opts)
    end
  end
end

require 'hypermodel/representation'
