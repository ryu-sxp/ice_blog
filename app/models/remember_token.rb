class RememberToken < ApplicationRecord
  belongs_to :user
  validates :token, uniqueness: true, allow_nil: true

end
