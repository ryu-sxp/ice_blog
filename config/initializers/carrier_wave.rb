require 'carrierwave/orm/activerecord'

def store_dimensions
  if file && model
    dimensions = model.image_dimensions
    if dimensions
      dimensions.push(::MiniMagick::Image.open(file.file)[:dimensions])
    else
      model.image_dimensions = [::MiniMagick::Image.open(file.file)[:dimensions]]
    end
  end
end

def store_dimensions_single
  if file && model
    model.image_dimensions = [::MiniMagick::Image.open(file.file)[:dimensions]]
  end
end

def resize_to_fit_png_scale(width, height)
  # results are no good, might as well use raw png and gif images
  # instead of thumbnails
  manipulate! do |img|
    if ['PNG', 'GIF'].include? img.type
      new_width = img.width
      new_height = img.height
      while (new_width > width) || (new_height > height) do
        new_width  = new_width/2
        new_height = new_height/2
      end
      img.scale "#{new_width}x#{new_height}"
      #img.sample "#{width}x#{height}"
    else
      #process! resize_to_fit: [a, b]
      if (img.width > width) || (img.height > height)
        width  = dimension_from width
        height = dimension_from height
        img.resize "#{width}x#{height}"
      end
    end
    img = yield(img) if block_given?
    img
  end
end

def scale_and_validate_dimension_equality(width, height)
  # results are no good, might as well use raw png and gif images
  # instead of thumbnails
  manipulate! do |img|
    if img.width != img.height
      raise CarrierWave::ProcessingError, "should have equal dimensions"
    end
    width  = dimension_from width
    height = dimension_from height
    img.scale "#{width}x#{height}"
    img = yield(img) if block_given?
    img
  end
end

def validate_dimension_equality
  manipulate! do |img|
    if img.width != img.height
      raise CarrierWave::ProcessingError, "should have equal dimensions"
    end
    img = yield(img) if block_given?
    img
  end
end

