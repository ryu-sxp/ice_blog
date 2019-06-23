class IpBlacklist < ApplicationRecord
  attr_accessor :comment_id
  validates :duration, presence: true, numericality: true
  validates :ip, presence: true, uniqueness: true

end
