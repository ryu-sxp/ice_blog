class Tag < ApplicationRecord
  self.per_page = 10
  belongs_to :blog_post
  validates :name, presence: true
end
