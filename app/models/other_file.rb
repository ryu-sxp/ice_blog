class OtherFile < ApplicationRecord
  mount_uploader :item, OtherFileUploader
  validates :item, presence: true

end
