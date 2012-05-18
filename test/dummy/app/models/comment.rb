class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :body, type: String

  embedded_in :post
end
