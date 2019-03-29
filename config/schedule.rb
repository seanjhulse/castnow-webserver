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
require File.expand_path(File.dirname(__FILE__) + "/environment")

set :output, {error: "#{Rails.root}/log/cron.log", standard: "#{Rails.root}/log/video_paths.txt"}

every 1.minute do
	command "cat /dev/null >| #{Rails.root}/log/video_paths.txt && #{Rails.root}/bin/refresh_network_share.sh"
end