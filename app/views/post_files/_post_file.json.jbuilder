json.extract! post_file, :id, :name, :item, :type, :image_dimensions, :created_at, :updated_at
json.url post_file_url(post_file, format: :json)
