json.extract! request, :id, :referer, :useragent, :request, :new_visitor, :is_bot, :counter_flag, :created_at, :updated_at
json.url request_url(request, format: :json)
