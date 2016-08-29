class GoogleApiService


  def self.place_detail(bot)
    location = geocode_parsing(bot)
    place_id = place_id_parsing(location, bot)
    url = "https://maps.googleapis.com/maps/api/place/details/json?placeid=#{place_id}&key=#{ENV['GOOGLE_API_KEY']}"
    response = RestClient.get(url)
    return JSON.parse(response)
  end

  def self.geocode_parsing(bot)
    url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{URI::escape(bot.street)} #{URI::escape(bot.city)}"
    response = RestClient.get(url)
    json = JSON.parse(response)
    location = { lat: json["results"][0]["geometry"]["location"]["lat"], lng: json["results"][0]["geometry"]["location"]["lng"] }
  end

  def self.place_id_parsing(location, bot)
    url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{location[:lat]},#{location[:lng]}&name=#{URI::escape(bot.shop_name)}&key=#{ENV['GOOGLE_API_KEY']}"
    response = RestClient.get(url)
    json = JSON.parse(response)
    return if json["status"] == "ZERO_RESULTS"
    places = json["results"].select{ |n| n["name"].length == bot.shop_name.length }
    place = places.select{ |n| n["vicinity"].length == "#{bot.street}, #{bot.city}".length }
    return place[0]["place_id"]
  end

end
