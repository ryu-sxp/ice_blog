json.extract! micropost, :id, :published_date, :content, :published, :created_at, :updated_at
json.url micropost_url(micropost, format: :json)
