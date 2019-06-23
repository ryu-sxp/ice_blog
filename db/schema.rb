# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180624075133) do

  create_table "audio_files", force: :cascade do |t|
    t.string "name"
    t.string "item"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "blog_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "blog_posts", force: :cascade do |t|
    t.string "title"
    t.string "icon"
    t.datetime "published_date"
    t.text "preview"
    t.string "toot"
    t.text "content"
    t.integer "toot_id", limit: 8
    t.integer "comments_c"
    t.boolean "published", default: false
    t.string "images"
    t.string "image_dimensions"
    t.integer "blog_category_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "draft"
    t.text "content_update"
    t.string "name"
    t.boolean "published_date_pending", default: false
    t.index ["blog_category_id"], name: "index_blog_posts_on_blog_category_id"
    t.index ["user_id"], name: "index_blog_posts_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.string "name"
    t.string "trip"
    t.string "email"
    t.string "website"
    t.string "source_model"
    t.integer "source_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "moderator_id"
    t.text "content"
    t.string "ip"
    t.string "useragent"
  end

  create_table "feeds", force: :cascade do |t|
    t.string "source_model"
    t.datetime "published_date"
    t.integer "source_id"
    t.boolean "published"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "image_files", force: :cascade do |t|
    t.string "name"
    t.string "item"
    t.string "image_dimensions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ip_blacklists", force: :cascade do |t|
    t.string "ip"
    t.integer "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "expires_at"
    t.string "reason"
    t.index ["ip"], name: "index_ip_blacklists_on_ip", unique: true
  end

  create_table "microposts", force: :cascade do |t|
    t.text "content"
    t.string "image"
    t.datetime "published_date"
    t.integer "toot_id", limit: 8
    t.integer "comments_c"
    t.boolean "published", default: true
    t.string "image_dimensions"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "sensitive"
    t.string "spoiler_text"
    t.string "video"
    t.string "filetoken"
    t.integer "media_id"
    t.string "visibility"
    t.boolean "relevant_media"
    t.index ["user_id"], name: "index_microposts_on_user_id"
  end

  create_table "other_files", force: :cascade do |t|
    t.string "name"
    t.string "item"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pending_toots", force: :cascade do |t|
    t.string "message"
    t.string "source_model"
    t.integer "source_id"
    t.integer "media_id"
    t.boolean "requires_file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "post_files", force: :cascade do |t|
    t.string "name"
    t.string "item"
    t.string "type"
    t.string "image_dimensions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_headers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.string "icon"
    t.text "content"
    t.boolean "published", default: false
    t.string "images"
    t.string "image_dimensions"
    t.integer "project_header_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "draft"
    t.text "content_update"
    t.index ["project_header_id"], name: "index_projects_on_project_header_id"
  end

  create_table "remember_tokens", force: :cascade do |t|
    t.string "token"
    t.datetime "expires_at"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "token"], name: "index_remember_tokens_on_user_id_and_token"
    t.index ["user_id"], name: "index_remember_tokens_on_user_id"
  end

  create_table "requests", force: :cascade do |t|
    t.string "referer"
    t.string "useragent"
    t.string "request"
    t.boolean "new_visitor"
    t.boolean "is_bot"
    t.boolean "counter_flag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["new_visitor", "counter_flag", "is_bot"], name: "index_requests_on_new_visitor_and_counter_flag_and_is_bot"
  end

  create_table "social_media_links", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.string "text"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_social_media_links_on_user_id"
  end

  create_table "spam_comments", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "website"
    t.text "content"
    t.string "blog_spam_result"
    t.string "blog_spam_reason"
    t.string "blog_spam_blocker"
    t.string "blog_spam_version"
    t.string "ip"
    t.string "useragent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "statistics", force: :cascade do |t|
    t.integer "requests_c"
    t.integer "visits_c"
    t.integer "bot_requests_c"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sticky_messages", force: :cascade do |t|
    t.text "content"
    t.text "draft"
    t.boolean "published"
    t.boolean "important"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sticky_messages_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.integer "blog_post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blog_post_id"], name: "index_tags_on_blog_post_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "theme"
    t.string "password_digest"
    t.boolean "admin", default: false
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.boolean "tweet_posts", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.string "avatar"
    t.string "about"
    t.string "forum_url"
    t.string "blog_post_toot_visibility", default: "unlisted"
    t.string "meta_keywords"
    t.string "meta_desc"
    t.string "site_name", default: "My Blog"
    t.string "site_slogan", default: "Powered by IceBlog"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "comment_flag"
    t.boolean "blog_spam_flag"
    t.string "site_banner"
    t.string "site_icon"
    t.text "bio"
    t.text "bio_draft"
    t.string "favicon"
    t.string "skin"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "video_files", force: :cascade do |t|
    t.string "name"
    t.string "item"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
