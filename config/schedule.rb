# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

env "DATABASE_NAME", ENV["DATABASE_NAME"]
env "DATABASE_USER", ENV["DATABASE_USER"]
env "DATABASE_HOST", ENV["DATABASE_HOST"]
env "DATABASE_PSWD", ENV["DATABASE_PSWD"]

every :day do
  runner "IceBlog::Cron.clear_comment_ips"
  runner "IceBlog::Cron.admin_reminder"
end

every :day, :at => '12:20am' do
  runner "IceBlog::Cron.clear_expired_remember_tokens"
end

every :day, :at => '12:30am' do
  runner "IceBlog::Cron.count_requests"
end

every :day, :at => '1:30am' do
  runner "IceBlog::Cron.clear_requests"
end

every :hour do
  runner "IceBlog::Cron.clear_ip_bans"
end
