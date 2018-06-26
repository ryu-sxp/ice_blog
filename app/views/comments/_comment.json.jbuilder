json.extract! comment, :id, :name, :trip, :email, :website, :blog_post_id, :micropost_id, :created_at, :updated_at
json.url comment_url(comment, format: :json)
