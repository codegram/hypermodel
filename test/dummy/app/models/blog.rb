class Blog
  include Mongoid::Document

  field :title
  has_many :posts
end
