require 'test_helper'
require 'json'

class PostsControllerTest < ActionController::TestCase
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

    post :show, { blog_id: @blog.id, id: @post.id, format: :json }
  end

  test "it returns a successful response" do
    assert response.successful?
  end

  test "returns the post" do
    body = JSON.load(response.body)

    assert_equal @post.id.to_s,  body['_id']
    assert_equal 'My post',      body['title']
    assert_equal 'Foo bar baz.', body['body']
  end

  test "returns the parent blog" do
    body = JSON.load(response.body)
    assert_equal blog_url(@blog), body['_links']['blog']['href']
  end

  test "returns the embedded comments" do
    body = JSON.load(response.body)

    assert_nil body['comments']
    comments = body['_embedded']['comments']

    assert_equal 'Comment 1', comments.first['body']
    assert_equal 'Comment 2', comments.last['body']
  end

  test "returns the self link" do
    body = JSON.load(response.body)
    assert_match /\/posts\/#{@post.id}/, body['_links']['self']['href']
  end

  test "returns the parent author" do
    body = JSON.load(response.body)

    assert_nil body['author']
    assert_match /\/authors\/#{@post.author.id}/, body['_links']['author']['href']
  end

  test "returns the links to its reviews" do
    body = JSON.load(response.body)

    assert_nil body['reviews']
    assert_match %r{/posts/#{@post.id}/reviews}, body['_links']['reviews']['href']
  end
end