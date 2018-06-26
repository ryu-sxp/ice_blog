json.extract! video_file, :id, :name, :item, :type, :created_at, :updated_at
json.url video_file_url(video_file, format: :json)
