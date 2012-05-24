class CommentsController < ApplicationController
  respond_to :json

  def index
    @blog     = Blog.find params[:blog_id]
    @post     = @blog.posts.find params[:post_id]
    @comments = @post.comments

    respond_with(@comments, responder: Hypermodel::Responder)
  end
end
