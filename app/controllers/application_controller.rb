class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :load_chromecast
  
  '''
    Grabs the current user from the session_id. No authentication required yet
    because its all local host
  '''
  def current_user
    if session[:current_user_id]
	  User.includes(:videos).find(session[:current_user_id]) || nil
    else
      nil
    end
  end

  '''
    Grabs the videos_path from the configuration file
  '''
  def videos_path
    YAML.load_file("#{Rails.root}/config/config.yml")["videos_path"]
  end

  '''
    Overwrites the existing videos_path config
  '''
  def update_videos_path(new_videos_path)
    configs = YAML.load_file "#{Rails.root}/config/config.yml"
    configs["videos_path"] = new_videos_path
    File.open("#{Rails.root}/config/config.yml", 'w') { |f| YAML.dump(configs, f) }
  end

  private
  def authenticate
    if !current_user
      redirect_to users_path
    end
  end

  def load_chromecast
    # initialized in /initialiers/chrome_cast.rb
    @chromecast = CHROMECAST
  end
end
