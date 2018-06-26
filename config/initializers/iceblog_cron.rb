module IceBlog

  module Cron

    def self.clear_expired_remember_tokens
      RememberToken.where("expires_at <= ?", Time.now.utc).destroy_all
    end

    def self.count_requests
      if Statistic.first.nil?
        Statistic.create(requests_c: Request.where(is_bot: false,
                                                   counter_flag: false).count,
                         bot_requests_c: Request.where(is_bot: true,
                                                       counter_flag: false).count,
                         visits_c: Request.where(is_bot: false, new_visitor: true,
                                                 counter_flag: false).count)
      else
        Statistic.first.update(requests_c: Statistic.first.requests_c +
                               Request.where(is_bot: false,
                                             counter_flag: false).count,
                               bot_requests_c: Statistic.first.bot_requests_c +
                               Request.where(is_bot: true,
                                             counter_flag: false).count,
                               visits_c: Statistic.first.visits_c +
                               Request.where(is_bot: false, new_visitor: true,
                                             counter_flag: false).count
                              
                              )
      end
      Request.where(counter_flag: false).update(counter_flag: true)
    end

    def self.clear_requests
      # TODO send mail with data or write a file before deleting
      # ... really though?
      Request.where("counter_flag = 't' AND created_at < ?", 1.months.ago.utc).
        destroy_all
    end

    def self.clear_ip_bans
      bans = IpBlacklist.all
      bans.each do |ban|
        if Time.now.to_i >= ban.created_at.to_i+ban.duration
          ban.destroy 
        end
      end
    end

    def self.clear_comment_ips
      comments = Comment.all
      comments.each do |com|
        if Time.now.to_i >=  com.created_at.to_i+604800
          com.update(ip: nil)
        end
      end
    end

    def self.admin_reminder
      User.find(1).send_reminder_mail
    end

    def self.push_toots
      toots = PendingToot.all.order('created_at ASC')
      if toots.count > 0
        toots.each do |toot|
          case toot.source_model
          when "blog_post"
            post = BlogPost.find(toot.source_id)
            if post
              if post.send_toot(post.user_id, toot.message) == 0
                toot.delete
              else
                break # api failed, try again later
              end
            else
              toot.delete # blog post no longer exists anyways
            end
          when "micropost"
            post = Micropost.find(toot.source_id)
            if post
              if post.send_toot(post.user_id) == 0
                toot.delete
              else
                break
              end
            else
              toot.delete
            end
          end
        end
      end
    end

  end


end

