class ImageFile < ApplicationRecord
  mount_uploader :item, ImageFileUploader

  #if Rails.env = "development"
    # workaround for json independent database
    serialize :image_dimensions, JSON
  #end
  validates :item, presence: true
end
