module MagicHelper
  def readable(title)
    File.basename(title,File.extname(title)).tr('^A-Za-z0-9', ' ').truncate(35).split.map{|x| x[0].upcase + x[1..-1]}.join(' ')
  end

  def movie_json(query)
    api_key = Rails.application.credentials.the_movie_db_key
    url = "https://api.themoviedb.org/3/search/movie?api_key=#{api_key}&language=en-US&query=#{query}&page=1&include_adult=false"
    response = HTTParty.get(url)
    movie = JSON.parse(response.body)
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
