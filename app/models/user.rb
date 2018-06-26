class User < ApplicationRecord
  has_many :remember_tokens, dependent: :destroy
  has_many :social_media_links, dependent: :destroy
  has_many :microposts, dependent: :destroy
  has_many :blog_posts, dependent: :destroy
  has_many :sticky_messages, dependent: :destroy
  attr_accessor :remember_token, :activation_token, :reset_token, :remember_id,
                :current_password
  before_save   :downcase_email
  before_create :create_activation_digest

  mount_uploader :avatar, AvatarUploader
  #mount_uploader :favicon, FaviconUploader
  mount_uploader :site_icon, SiteIconUploader
  mount_uploader :site_banner, SiteBannerUploader

  VALID_EMAIL_REGEX    = /.+@.+/i
  VALID_USERNAME_REGEX = /\A[a-zA-Z0-9_]+\z/

  validates :name,  presence: true, length: { maximum: 26 },
                    format: { with: VALID_USERNAME_REGEX }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validate :avatar_size_validation
  validates_processing_of :site_icon

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember(expiration)
    self.remember_token = User.new_token
    while true do
=begin
      if o = self.remember_tokens.create(token: User.digest(remember_token),
                                         expires_at: expiration.strftime(
                                           "%Y-%m-%d %H:%M:%S")
                                        )
=end
      if o = self.remember_tokens.create(token: User.digest(remember_token),
                                         expires_at: expiration)
        # then
        self.remember_id = o.id
        break
      end
    end
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def is_remembered?(token)
    if rtoken = find_remember_token(token)
      self.remember_id = rtoken.id
      return true
    end
    false
  end

  def forget(token)
    if rtoken = find_remember_token(token)
      rtoken.destroy
    end
  end

  def is_admin?
    self.admin?
  end

  def is_activated?
    self.activated?
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def send_password_reset_mail
    UserMailer.password_reset(self).deliver_now
  end

  def send_comment_mail(comment)
    UserMailer.comment_announce(self, comment).deliver_now
  end

  def send_reminder_mail()
    UserMailer.reminder(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

    def check_current_password
      unless self.authenticate(current_password)
        errors.add(:current_password, "is invalid.")
      end
    end

    def downcase_email
      self.email = email.downcase
    end

    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

    def avatar_size_validation
      if !avatar.nil? && avatar.size > 0.5.megabytes
        errors.add(:avatar, "should be less than 500KB")
      end
    end

    def find_remember_token(token)
      # token comes from cookie
      limit = 10
      i     = 0
      self.remember_tokens.each do |rtoken|
        return false if i == limit
        unless rtoken.token.nil?
          i += 1
          if BCrypt::Password.new(rtoken.token).is_password?(token)
            return rtoken
          end
        end
      end
      false
    end

end
