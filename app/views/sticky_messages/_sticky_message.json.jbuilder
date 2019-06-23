json.extract! sticky_message, :id, :content, :draft, :published, :important, :user, :created_at, :updated_at
json.url sticky_message_url(sticky_message, format: :json)
