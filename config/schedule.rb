# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, "/home/jsomers/www/readertron/log/cron.log"
#
every 1.hour do
  runner "Feed.refresh"
end

every 1.day do
  runner "Report.daily"
end

# Learn more: http://github.com/javan/whenever