class MagicController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate
  before_action :get_movies
  before_action :get_shows
  before_action :load_chromecast
  include MagicHelper

  def movies
  end

  def episodes
    show_path = params[:show].to_s
    @show = show_json(readable(show_path))
    @seasons = get_seasons(show_path)
  end

  def cast
    # find an existing video record
    @video = current_user.videos.where(title: params[:title]).first_or_create
    @poster = params[:video][:poster]

  	# play movie on instance
    @chromecast.cast(@video.path, @video.seek)
    
    respond_to do |format|
      format.js { render 'play.js.erb'}
    end
  end

  def play
    @chromecast.play
    respond_to do |format|
      format.js { render 'toggle.js.erb'}
    end
  end

  def pause
    @chromecast.pause
    respond_to do |format|
      format.js { render 'toggle.js.erb'}
    end
  end

  def sound_down
    @chromecast.sound_down
    respond_to do |format|
      format.js { render 'toggle_sound.js.erb'}
    end
  end

  def sound_up
    @chromecast.sound_down
    respond_to do |format|
      format.js { render 'toggle_sound.js.erb'}
    end
  end

  def sound_off
    @chromecast.sound_off
    respond_to do |format|
      format.js { render 'toggle_sound.js.erb'}
    end
  end

  def sound_on
    @chromecast.sound_off
    respond_to do |format|
      format.js { render 'toggle_sound.js.erb'}
    end
  end

  def stop
    # stop movie playing on instance
    @chromecast.stop
    respond_to do |format|
      format.js { render 'stop.js.erb'}
    end
  end
  
  def seek
    # seek ffwd or rewind
    @chromecast.manual_seek(params[:direction])
  end

  # gets the time and updates our video row with the new time (so we can track usage of video)
  def time
    # get the time and update it
    @video = current_user.videos.where(path: @chromecast.path).first_or_create
    @video.update(seek: @chromecast.time)
  end

  private
  def get_movies
    @movies = Dir[videos_path + '**/*.*'].sort_by!{ |m| m.downcase }
  end

  def get_shows
    @shows = Dir[videos_path + '**/*/'].sort_by!{ |m| m.downcase }
  end

  def get_seasons(show)
    Dir["#{show}**/*/"].sort_by!{ |m| m.downcase }
  end

  def video_params
    params.require(:video).permit(:id, :path, :seek, :title, :user_id)
  end
end
