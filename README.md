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