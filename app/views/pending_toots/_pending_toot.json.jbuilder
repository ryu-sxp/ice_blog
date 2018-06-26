json.extract! pending_toot, :id, :message, :source_model, :source_id, :media_id, :requires_file, :created_at, :updated_at
json.url pending_toot_url(pending_toot, format: :json)
