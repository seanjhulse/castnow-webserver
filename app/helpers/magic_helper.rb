module MagicHelper
  def readable(title)
    File.basename(title,File.extname(title)).tr('^A-Za-z0-9', ' ').truncate(35).split.map{|x| x[0].upcase + x[1..-1]}.join(' ')
  end

  def movie_json(query)
    api_key = Rails.application.credentials.the_movie_db_key
    url = "https://api.themoviedb.org/3/search/movie?api_key=#{api_key}&language=en-US&query=#{query}&page=1&include_adult=false"
    movie = Rails.cache.redis.get(url)
    return JSON.parse(movie) unless movie.nil?

    response = HTTParty.get(url)
    movie = JSON.parse(response.body)
    Rails.cache.redis.set(url, response.body)
    return movie
  end

  def show_json(query)
    api_key = Rails.application.credentials.the_movie_db_key
    url = "https://api.themoviedb.org/3/search/tv?api_key=#{api_key}&language=en-US&query=#{query}&page=1&include_adult=false"
    show = Rails.cache.redis.get(url)
    return JSON.parse(show) unless show.nil?

    response = HTTParty.get(url)
    show = JSON.parse(response.body)
    Rails.cache.redis.set(url, response.body)
    return show
  end

  def get_episodes(show)
    Dir["#{show}*"].sort_by!{ |m| m.downcase }
  end

  def movie_title(data)
    data["results"][0]["title"]
  end

  def movie_poster(data)
    "https://image.tmdb.org/t/p/w185/#{data['results'][0]['poster_path']}"
  end

  def movie_description(data)
    data["results"][0]["overview"]
  end

  def movie_release_date(data)
    data["results"][0]["release_date"]
  end
  
  def movie_rating(data)
    data["results"][0]["vote_average"]
  end
end
