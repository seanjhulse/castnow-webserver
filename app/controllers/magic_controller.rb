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

  def play
    id = params[:id].to_i
    path = @movies[id].to_s

    # play movie on instance
    @chromecast.play(path)
    
    respond_to do |format|
      format.js { render 'play.js.erb'}
    end
  end

  def play_pause
    # toggle play and pause state
    @chromecast.toggle
    respond_to do |format|
      format.js { render 'toggle.js.erb'}
    end
  end

  def sound_toggle
    @chromecast.toggle_sound
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
    # seek forwards or backwards
    @chromecast.seek(params[:direction])
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
  
  def load_chromecast
    # initialized in /initialiers/chrome_cast.rb
    @chromecast = CHROMECAST
  end

end
