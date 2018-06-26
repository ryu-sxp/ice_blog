class VideoFile < ApplicationRecord
  mount_uploader :item, VideoFileUploader
  validates :item, presence: true
end
