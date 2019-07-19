def app_config_secret(id)
end

module IceBlog
  def self.version
    '1.2'
  end

  def self.url
    if Rails.env == 'development'
      'localhost'
    else
      'http://www.example.com'
    end
  end

  def self.config(id)
    case id
    when :admin_email
      ''
    when :thumb_width
      320
    when :thumb_height
      400
    when :large_thumb_width
      640
    when :large_thumb_height
      800
    when :icon_width
      80
    when :icon_height
      80
    when :deploy_year
      2015
    when :trip_salt_dev
      ""
    when :themes
      ['ellis']
    when :skins
      { ellis: ['ellis', 'darkside']}
    end
  end

  def self.secrets(id)
  end

  def self.get_mastodon_client
    if Rails.env == "production"
      url           = ENV['MSTDN_URL']
      client_user = ENV['MSTDN_USERNAME']
      access_token  = ENV['MSTDN_ACCESS_TOKEN']
    else
      url           = self.secrets(:mastodon_url)
      client_user = self.secrets(:mastodon_username)
      access_token  = self.secrets(:mastodon_access_token)
    end
    client = Saturnexplorers::Mastodon::Client.new(url, access_token,
                                                   client_user)
  end

  def self.get_twitter_client
    # dependency problem with twitter and mastodon api
    # thus the twitter functionality is disabled
    if Rails.env == "production"
      consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      access_token        = ENV['TWITTER_ACCESS_TOKEN']
      access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    else
      consumer_key        = self.secrets(:twitter_consumer_key)
      consumer_secret     = self.secrets(:twitter_consumer_secret)
      access_token        = self.secrets(:twitter_access_token)
      access_token_secret = self.secrets(:twitter_access_token_secret)
    end
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = consumer_key
      config.consumer_secret     = consumer_secret
      config.access_token        = access_token
      config.access_token_secret = access_token_secret
    end
  end
end
