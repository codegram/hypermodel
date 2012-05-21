class PostsController < ApplicationController
  respond_to :json

  def show
    @blog = Blog.find params[:blog_id]
    @post = @blog.posts.find params[:id]
    respond_with(@post, responder: Hypermodel::Responder)
  end
end
