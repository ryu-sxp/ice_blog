json.extract! spam_comment, :id, :name, :email, :website, :content, :blog_spam_result, :blog_spam_reason, :blog_spam_blocker, :blog_spam_version, :ip, :useragent, :created_at, :updated_at
json.url spam_comment_url(spam_comment, format: :json)
