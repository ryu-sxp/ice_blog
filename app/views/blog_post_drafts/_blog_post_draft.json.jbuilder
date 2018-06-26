json.extract! blog_post_draft, :id, :name, :content, :published, :created_at, :updated_at
json.url blog_post_draft_url(blog_post_draft, format: :json)
