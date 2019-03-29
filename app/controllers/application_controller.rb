class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  '''
    Grabs the current user from the session_id. No authentication required yet
    because its all local host
  '''
  def current_user
    if session[:current_user_id]
      User.find(session[:current_user_id])
    else
      nil
    end
  end

  '''
		Returns an array of known network shared drives from this file located in logs.
		The file is updated with a cron job run by the `whenever` gem.
	'''
	def video_paths
    video_paths = []
    if File.exist?("#{Rails.root}/log/video_paths.txt")
      File.open("#{Rails.root}/log/video_paths.txt", "r").each_line do |line|
        video_paths.push(line.strip);
      end
    end
    video_paths
  end

  private
  def authenticate
    if !current_user
      redirect_to users_path
    end
  end
end
