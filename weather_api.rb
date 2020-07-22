require 'geocoder'
require 'date'
require 'json'
require 'open-uri'

def fetch_weather(message)
  # Accepted message:
  # ~~~~~ weather in XXXXX
  #  ^anything          ^will become the location
  location = message.match(/.+weather in (\w+).*/)[1]

  # Coordinates from keyword
  coord = Geocoder.search(location).first.coordinates
  api_key = ENV["WEATHER_API"]
  api_key = "f5191f73c320e67df9461049016befe3"
  url = "https://api.openweathermap.org/data/2.5/onecall?lat=#{coord[0]}&lon=#{coord[1]}&exclude=current,minutely,hourly&appid=#{api_key}"
  begin
    data_serialized = open(url).read
  rescue OpenURI::HTTPError => e
    return {mostly: "", temps: "", report: "No weather forecast for this city..."}
  end
  data = JSON.parse(data_serialized)['daily'][0..3]

  days = ["today", "tomorrow", (Date.today+ 2).strftime('%A'), (Date.today+ 3).strftime('%A')]
  weather_forcast = data.map.with_index { |day, index| [days[index], day['weather'][0]['main'], day['temp']['day'] - 272.15] }
  freq = weather_forcast.map {|day| day[1]}.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
  most_freq_weather = freq.max_by{|k,v| v}[0]

  # Report creation
  report = "The weather is mostly #{most_freq_weather.upcase} in #{location} for the next 4 days.\n"
  # If there are particular weather days
  other_weathers = weather_forcast.reject { |day| day[1] == most_freq_weather}
  report += "Except on #{other_weathers.map { |day| "#{day[0]}(#{day[1]})" }.join(", ")}.\n" if other_weathers.any?
  #tempreatures
  report += "\nThe temperature will be:\n#{weather_forcast.map {|day| " #{day[2].round}˚C for #{day[0]}"}.join("\n")}"
  # Return an hash with the created weather fore_cast data
  {mostly: most_freq_weather, weather_forcast: weather_forcast, report: report}
end
