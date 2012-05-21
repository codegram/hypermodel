# hypermodel [![Build Status](https://secure.travis-ci.org/codegram/hypermodel.png)](http://travis-ci.org/codegram/hypermodel) [![Dependency Status](https://gemnasium.com/codegram/hypermodel.png)](http://gemnasium.com/codegram/hypermodel)

A Rails Responder that renders any [Mongoid][mongoid] model to a [JSON HAL
format][hal], suitable for Hypermedia APIs.

## Install

Put this in your Gemfile:

    gem 'hypermodel'

## Usage

````ruby
class PostsController < ApplicationController
  respond_to :json

  def show
    @post = Post.find params[:id]
    respond_with(@post, responder: Hypermodel::Responder)
  end
end
````

Now if you ask your API for a Post:

    {"_id"=>"4fb648996b98c90919000012",
     "title"=>"My post",
     "body"=>"Foo bar baz.",
     "author_id"=>"4fb648996b98c9091900000f",
     "updated_at"=>"2012-05-18T13:03:21Z",
     "created_at"=>"2012-05-18T13:03:21Z",
     "_links"=>
      {"self"=>{"href"=>"http://test.host/posts/4fb648996b98c90919000012"},
       "author"=>{"href"=>"http://test.host/authors/4fb648996b98c9091900000f"},
       "reviews"=>
        {"href"=>"http://test.host/posts/4fb648996b98c90919000012/reviews"}},
     "_embedded"=>
      {"comments"=>
        [{"_id"=>"4fb648996b98c9091900000d", "body"=>"Comment 1"},
         {"_id"=>"4fb648996b98c9091900000e", "body"=>"Comment 2"}]}}

## Gotchas

These are some implementation gotchas which are welcome to be fixed if you can
think of workarounds :)

### Routes should reflect data model

For Hypermodel to generate `_links` correctly, the relationship/embedding
structure of the model must match exactly that of the app routing. That means,
that if you have `Blogs` that have many `Posts` which have many `Comments`,
the routes.rb file should reflect it:

````ruby
# config/routes.rb
resources :blogs do
  resources :posts do
    resources :comments
  end
end
````

### Every resource controller must implement the :show action at least

Each resource and subresource must respond to the `show` action (so they can be
linked from anywhere, in the `_links` section).

### The first belongs_to decides the hierarchy chain

So if a `Post` belongs to an author and to a blog, and you want to access
posts through blogs, not authors, you have to put the `belongs_to :blog`
**before** `belongs_to :author`:

````ruby
# app/models/post.rb
class Post
  include Mongoid::Document

  belongs_to :blog
  belongs_to :author
end
````

I know, lame.

## Contributing

* [List of hypermodel contributors][contributors]

* Fork the project.
* Make your feature addition or bug fix.
* Add specs for it. This is important so we don't break it in a future
  version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  If you want to have your own version, that is fine but bump version
  in a commit by itself I can ignore when I pull.
* Send me a pull request. Bonus points for topic branches.

## License

MIT License. Copyright 2012 [Codegram Technologies][codegram]

[mongoid]: http://mongoid.org
[hal]: http://stateless.co/hal_specification.html
[contributors]: https://github.com/codegram/hypermodel/contributors
[codegram]: http://codegram.com