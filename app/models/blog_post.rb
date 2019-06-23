class BlogPost < ApplicationRecord
  attr_accessor :previous_category_id
  self.per_page = 10
  has_many :tags, dependent: :destroy
  #belongs_to :blog_post_draft
  belongs_to :user

  after_destroy :clean_category
  after_destroy :clean_feed
  after_destroy :delete_toot
  before_update :published_date_validation
  after_save    :write_feed
  #after_save :clean_image_dimensions

  #mount_uploaders :images, BlogImageUploader
  mount_uploader  :icon,   BlogIconUploader

  validates :toot, length: { maximum: 512 }
  validates :title, length: { maximum: 256 }
  validates :draft, presence: true
  validate  :content_yaml_check

  #validate :image_size_validation
  validates_processing_of :icon
  validate :icon_size_validation

  #if Rails.env = "development"
    # workaround for json independent database
  #  serialize :images, JSON
  #  serialize :image_dimensions, JSON
  #end
  
  def clean_category_update
    if BlogPost.where(blog_category_id: self.previous_category_id).count == 0
      if cat = BlogCategory.find_by(id: self.previous_category_id)
        cat.delete
      end
    end
  end 

  def content_yaml_check
    /\A---(.+)---/m =~ self.draft
    if $~
      if $~.to_s.include? "!ruby"
        self.errors.add :draft, "Invalid YAML frontmatter"
      else
        data = YAML.load($~.to_s)
        if data.is_a?(Hash)
          if (data.has_key?("title") && data.has_key?("date") &&
              data.has_key?("category") && data.has_key?("tags") &&
              data.has_key?("preview") && data.has_key?("toot")) ==
              false || data.size > 6
            self.errors.add :draft, "Invalid YAML keys(invalid hash)"
          elsif data["tags"].is_a?(Array) == false
            self.errors.add :draft, "Invalid YAML keys(tags not an array)"
          end
        else
            self.errors.add :draft, "Invalid YAML keys(not a hash)"
        end
      end
    else
      self.errors.add :draft, "Invalid YAML frontmatter"
    end
  end

  private

    def delete_toot
      if self.toot_id
          client = IceBlog::get_mastodon_client
          toot = client.status_get(self.toot_id)
          if toot.error? == false
            client.status_delete(toot.id)
        end
      end
    end

    def clean_image_dimensions
      if image_dimensions
        if images
          remove_c = image_dimensions.size - images.size
          if remove_c > 0
            self.image_dimensions = image_dimensions.drop(remove_c)
            self.save
          end
        else
          self.image_dimensions = nil
          self.save
        end
      end
    end

    def clean_category
      if BlogPost.where(blog_category_id: self.blog_category_id).count == 0
        if cat = BlogCategory.find_by(id: self.blog_category_id)
          cat.delete
        end
      end
    end 

    def clean_feed
      Feed.where(source_id: self.id, source_model: "blog_post").delete_all
    end
    
    def write_feed
      if feed = Feed.find_by(source_model: "blog_post", source_id: self.id)
        feed.update(published: self.published,
                    published_date: self.published_date)
      else
        Feed.create(source_model: "blog_post", source_id: self.id,
                    published: false)
      end
    end

    def image_size_validation
      if images
        images.each do |img|
          if img.size > 1.megabytes
            errors.add(:images, "should be less than 500KB each")
          end
        end
      end
    end

    def icon_size_validation
      if icon && icon.size > 0.3.megabytes
        errors.add(:icon, "should be less than 300KB")
      end
    end

    def icon_dimension_validation
      unless icon
        if icon.width == icon.height
          errors.add(:icon, " requires equal dimensions")
        end
      end
    end

    def published_date_validation
      unless self.published_date.present?
        self.published_date = Time.now
        self.published_date_pending = true
      end
    end


end
