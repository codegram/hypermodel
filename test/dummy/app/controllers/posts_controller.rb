class PostsController < ApplicationController
  respond_to :json

  def show
    @post = Post.find params[:id]
    respond_with(@post, responder: Hypermodel::Responder)
  end
end
