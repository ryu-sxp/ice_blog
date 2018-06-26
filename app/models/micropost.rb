class Micropost < ApplicationRecord
  self.per_page = 10
  belongs_to :user
  after_destroy :clean_feed
  after_destroy :delete_toot
  after_save    :write_feed

  mount_uploader :image, MircopostImageUploader
  mount_uploader :video, MicropostVideoUploader

  validates :content, presence: true, length: { maximum: 500 }
  validate :image_size_validation
  validate :media_limit

  #if Rails.env = "development"
    # workaround for json independent database
    serialize :image_dimensions, JSON
  #end

  private

    def media_limit
      if self.image.present? && self.video.present?
        errors.add(:image, "only one file can be uploaded")
        errors.add(:video, "only one file can be uplaoded")
      end
    end

    def delete_tweet
      if self.tweet_id
        begin
          client = IceBlog::get_twitter_client
          tweet = client.status(self.tweet_id)
        rescue Twitter::Error::NotFound
        end
        if tweet
          client.destroy_status(tweet)
        end
      end
    end

    def delete_toot
      if self.toot_id
          client = IceBlog::get_mastodon_client
          toot = client.status_get(self.toot_id)
          if toot.error? == false
            client.status_delete(toot.id)
        end
      end
    end

    def image_size_validation
      if !image.nil? && image.size > 1.megabytes
        errors.add(:image, "should be less than 1mb")
      end
    end

    def clean_feed
      Feed.where(source_id: self.id, source_model: "micropost").delete_all
    end
    
    def write_feed
      if feed = Feed.find_by(source_model: "micropost", source_id: self.id)
        feed.update(published: self.published,
                    published_date: self.published_date)
      else
        Feed.create(source_model: "micropost", source_id: self.id,
                    published: self.published,
                    published_date: self.published_date)
      end
    end

end
