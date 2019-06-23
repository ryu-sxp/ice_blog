class ProjectHeader < ApplicationRecord
  validates :name, presence: true, length: { maximum: 26 },
                   uniqueness: { case_sensitive: false }
end
