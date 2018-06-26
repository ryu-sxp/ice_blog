#require "saturnexplorers/mastodon/version"
#require "mastodon/version"
require 'net/http'
require 'uri'
require 'json'
require 'has_properties'

module Saturnexplorers

  ##
  # Alternative interface to the Mastodon API
  # has working media upload and less dependencies than the original gem

  module Mastodon

    class Base

      ##
      # Checks if the result failed
      # If this returns true the object has a msg
      # attribute that may tell you what went wrong

      def error?
        self.is_a? Error
      end

    end

    class Client

      def initialize(instance_url, access_token, username)
        @instance_url = instance_url
        @access_token = access_token
        @username     = username

        @useragent    = 'IceBlog Mastodon API Interface'
      end

      ##
      # Returns the current user

      def user_get
        req_objs = get_http_request({request: 'get',authorize: true,
                         api_endpoint: "/api/v1/accounts/verify_credentials"})
        
        begin
          response = req_objs[0].request(req_objs[1])
        rescue Exception => o
          error = Error.new("NO RESPONSE: #{o}")
          return error
        end

        unless request_failed? response

          response = JSON.parse(response.body)
          response = symbolize_keys response

          account = Account.new response

          return account
        else
          error = Error.new(response.body) 
          return error
        end

      end


      ##
      # Fetches a status by its ID
      # and returns it as a status object

      def status_get(id)
        req_objs = get_http_request({request: 'get',authorize: false,
                               api_endpoint: "/api/v1/statuses/#{id}"})
        
        begin
          response = req_objs[0].request(req_objs[1])
        rescue Exception => o
          error = Error.new("NO RESPONSE: #{o}")
          return error
        end

        unless request_failed? response

          response = JSON.parse(response.body)
          response = symbolize_keys response

          status = Status.new response

          return status
        else
          error = Error.new(response.body) 
          return error
        end

      end

      ##
      # Deletes status by its ID
      # returns empty status object

      def status_delete(id)
        req_objs = get_http_request({request: 'delete',
                               api_endpoint: "/api/v1/statuses/#{id}"})

        begin
          response = req_objs[0].request(req_objs[1])
        rescue Exception => o
          error = Error.new("NO RESPONSE: #{o}")
          return error
        end

        unless request_failed? response

          response = JSON.parse(response.body)
          response = symbolize_keys response

          status = Status.new response

          return status
        else
          error = Error.new(response.body) 
          return error
        end

      end

      ##
      # Creates a new status. arg1 is string of the micropost, arg2 a
      # hash of options that takes the following optional keys:
      # in_reply_to_id
      # media_ids (array) (as array[]=value1&array[]=value2)
      # convention for media ids:
      # {'media_ids[]': [0,1,2...]}
      # sensitive
      # spoiler_text
      # visibility (direct, private, unlisted, public)

      def status_put(text, options = {})
        req_objs = get_http_request({request: 'post',
                                    api_endpoint: '/api/v1/statuses',
                                    idemp: true})

        form_data = {status: "#{text}"}.merge(options)
        req_objs[1].set_form_data(form_data)

        begin
          response = req_objs[0].request(req_objs[1])
        rescue Exception => o
          error = Error.new("NO RESPONSE: #{o}")
          return error
        end

        unless request_failed? response

          response = JSON.parse(response.body)
          response = symbolize_keys response

          status = Status.new response

          return status
        else
          error = Error.new(response.body)
          return error
        end
      end

      ##
      # Uploads a file
      # arg1 the file handle
      # arg2 a description for visually impaired (optional)
      # arg3 a focal point (comma separated string with x and y coordinates)
      
      def media_put(file, desc = nil, focus = nil)
        req_objs = get_http_request({request: 'post',
                                    api_endpoint: '/api/v1/media'})

        form_data = [['file', file]]
        req_objs[1].set_form form_data, 'multipart/form-data'

        begin
          response = req_objs[0].request(req_objs[1])
        rescue Exception => o
          error = Error.new("NO RESPONSE: #{o}")
          return error
        end

        unless request_failed? response

          response = JSON.parse(response.body)
          response = symbolize_keys response

          media = Media.new response

          return media
        else
          error = Error.new(response.body)
          return error
        end
      end



        private

          def get_http_request(options = {})

            auth  = options.has_key?(:authorize) ? options[:authorize] : true
            idemp = options.has_key?(:idemp) ? options[:idemp] : false
            restype      = options[:request]
            api_endpoint = options[:api_endpoint]

            uri = URI.parse(@instance_url)
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true
            case restype
            when 'post'
              request = Net::HTTP::Post.new(api_endpoint,
                                            {'User-Agent' => @useragent})
            when 'get'
              request = Net::HTTP::Get.new(api_endpoint,
                                            {'User-Agent' => @useragent})
            when 'delete'
              request = Net::HTTP::Delete.new(api_endpoint,
                                            {'User-Agent' => @useragent})
            end
            if auth
              request.add_field('Authorization', "Bearer #{@access_token}")
            end
            if idemp
              request.add_field('Idempotency-Key', Time.now.to_i)
            end
            [http, request]
          end

          def symbolize_keys(hash)
            hash.keys.each do |key|
              hash[(key.to_sym rescue key) || key] = hash.delete(key)
            end
            hash
          end

          def request_failed?(response)
            response.code != '200'
          end
    end

    class Status < Base
      include HasProperties
      has_read_properties :id,
                          :uri,
                          :url,
                          :account,
                          :in_reply_to_id,
                          :in_reply_to_account_id,
                          :reblog,
                          :content,
                          :created_at,
                          :emojis,
                          :reblogs_count,
                          :favourites_count,
                          :reblogged,
                          :favourited,
                          :muted,
                          :sensitive,
                          :spoiler_text,
                          :visibility,
                          :media_attachments,
                          :mentions,
                          :tags,
                          :application,
                          :language,
                          :pinned

    end

    class Media < Base
      include HasProperties
      has_read_properties :id,
                          :type,
                          :url,
                          :remote_url,
                          :preview_url,
                          :text_url,
                          :meta,
                          :description
    end

    class Account < Base
      include HasProperties
      has_read_properties :id,
                          :username,
                          :acct,
                          :display_name,
                          :locked,
                          :created_at,
                          :followers_count,
                          :following_count,
                          :statuses_count,
                          :note,
                          :url,
                          :avatar,
                          :avatar_static,
                          :header,
                          :header_static,
                          :moved,
                          :source
    end

    class Error < Base
      attr_reader :msg
      def initialize(msg)
        msg = "The request to #{@instance_url} failed with the following response: \n\n\n"+msg
        @msg = msg
      end
    end
      

  end
end
