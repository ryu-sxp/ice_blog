json.extract! ip_blacklist, :id, :ip, :duration, :created_at, :updated_at
json.url ip_blacklist_url(ip_blacklist, format: :json)
