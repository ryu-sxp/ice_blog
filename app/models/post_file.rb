class PostFile < ApplicationRecord
  mount_uploader :item, FileUploader


  #if Rails.env = "development"
    # workaround for json independent database
    serialize :image_dimensions, JSON
  #end

  private

end
