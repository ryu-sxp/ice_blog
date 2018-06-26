class AudioFile < ApplicationRecord
  mount_uploader :item, AudioFileUploader

  validates :item, presence: true
end
