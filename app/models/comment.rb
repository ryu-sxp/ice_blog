class Comment < ApplicationRecord
  attr_accessor :name_backup
  validates :name, length: { maximum: 26 }
  validates :email, length: { maximum: 256 }
  validates :website, length: { maximum: 256 }
  validates :content, presence: true, length: { maximum: 500 }
  validate  :check_comment_flag
  validate  :check_blacklist

  before_validation :trip_code_handling

  private
    
    def trip_code_handling
      self.name_backup = self.name
      if self.name.present? && self.name.include?('#')
        if Rails.env == 'development'
          trip_salt = IceBlog.config(:trip_salt_dev)
        else
          trip_salt = ENV['TRIP_SALT']
        end
        ar = self.name.split('#')
        self.name = ar.shift
        trip_kari = ""
        i = 0
        j = 0
        ar.each do |str|
          if i == 0
            trip_kari = Digest::SHA256.base64digest(trip_salt+str)
            j += 1
          elsif i > 0 && i < 3
            # ignore too many hash requests
            trip_kari = Digest::SHA256.base64digest(trip_kari+str)
            j += 1
          end
          i += 1
        end
        self.trip = "!" * j + trip_kari[0,10]
        self.name.strip!
      elsif !self.name.present?
        self.name = "anonymous"
      end
    end

    def check_comment_flag
      unless User.find(1).comment_flag
        errors[:base] << "Sorry, commenting is currently disabled."
      end
    end
    
    def check_blacklist
      check = IpBlacklist.where(ip: self.ip)
      if check.count > 0
        errors[:base] << "You are currently banned."
      end
    end

end
