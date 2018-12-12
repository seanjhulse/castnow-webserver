class MagicController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :get_movies
  before_action :load_chromecast
  include MagicHelper

  def movies
    @baseURI = 'https://api.themoviedb.org/3/search/movie?api_key=' + ENV['themoviedb_api_key'] + '&language=en-US&query='
    @limits = '&page=1&include_adult=false'

    @movie_images = []
    @movies.each_with_index do |movie|
      # create request
      request = @baseURI + readable(movie).tr("0-9", "").gsub(" ", "%20") + @limits

      # cache response native Rails caching client
      Rails.cache.fetch(request, :expires => 3.days) do
        response = HTTParty.get(request)
        if response.success?
          results = response['results'][0]
          unless results.nil?
            poster_path = results['poster_path']
            poster_url = 'http://image.tmdb.org/t/p/w185' + poster_path
            @movie_images.push(poster_url)
          else
            @movie_images.push(nil)
          end
        end
      end
    end
  end

  def play
    id = params[:id].to_i
    path = @movies[id].to_s

    # play movie on instance
    @chromecast.play(path)
    
    @message = "Loading your movie"
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
    @home_path = "/home/sean/Videos/"
    @movies = Dir[@home_path + '*'].sort_by!{ |m| m.downcase }
  end
  def load_chromecast
    # initialized in /initialiers/chrome_cast.rb
    @chromecast = CHROMECAST
  end

end
