json.extract! social_media_link, :id, :name, :url, :text, :user_id, :created_at, :updated_at
json.url social_media_link_url(social_media_link, format: :json)
