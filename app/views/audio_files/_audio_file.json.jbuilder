json.extract! audio_file, :id, :name, :item, :type, :created_at, :updated_at
json.url audio_file_url(audio_file, format: :json)
