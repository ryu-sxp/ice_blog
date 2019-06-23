json.extract! image_file, :id, :name, :item, :type, :image_dimensions, :created_at, :updated_at
json.url image_file_url(image_file, format: :json)
