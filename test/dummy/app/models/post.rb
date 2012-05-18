class Post
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :body, type: String

  belongs_to :author
  has_many :reviews
  embeds_many :comments
end
