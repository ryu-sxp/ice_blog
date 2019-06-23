json.extract! blog_category, :id, :name, :created_at, :updated_at
json.url blog_category_url(blog_category, format: :json)
