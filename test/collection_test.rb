require 'test_helper'
require 'json'

class CollectionTest < ActionController::TestCase
  tests CommentsController

  def setup
    @blog = Blog.create(title: 'Rants')
    @post = Post.create(
      title: "My post",
      body: "Foo bar baz.",
      comments: [
        Comment.new(body: 'Comment 1'),
        Comment.new(body: 'Comment 2'),
      ],
      author: Author.create(name: 'John Smith'),
      reviews: [
        Review.create(body: 'This is bad'),
        Review.create(body: 'This is good'),
      ],
      blog_id: @blog.id
    )
    @comments = @post.comments

    post :index, { blog_id: @blog.id, post_id: @post.id, format: :json }
  end

  test "it returns a successful response" do
    assert response.successful?
  end

  test "returns the self link" do
    body = JSON.load(response.body)
    assert_match %r{/comments}, body['_links']['self']['href']
  end

  test "returns the comments" do
    body = JSON.load(response.body)

    comments = body['_embedded']['comments']

    first = @comments.first
    last  = @comments.last

    assert_equal first.id.to_s, comments.first['_id']
    assert_equal first.body,    comments.first['body']

    assert_equal last.id.to_s,  comments.last['_id']
    assert_equal last.body,     comments.last['body']
  end

  test "returns the parent post" do
    body = JSON.load(response.body)
    assert_equal blog_post_url(@blog, @post), body['_links']['post']['href']
  end
end