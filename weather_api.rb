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
  # ENV["WEATHER_API"]
  coord = Geocoder.search(location).first.coordinates
  api_key = "f5191f73c320e67df9461049016befe3"
  url = "https://api.openweathermap.org/data/2.5/onecall?lat=#{coord[0]}&lon=#{coord[1]}&exclude=current,minutely,hourly&appid=#{api_key}"
  begin
    data_serialized = open(url).read
  rescue OpenURI::HTTPError => e
    return {mostly: "", temps: "", report: "No weather forecast for this city..."}
  end
  data = JSON.parse(data_serialized)['daily'][0..3]

  weather_for = []
  temp_for = []
  days = ["today", "tomorrow", (Date.today+ 2).strftime('%A'), (Date.today+ 3).strftime('%A')]
  data.each_with_index do |day, index|
    weather_for << [days[index], day['weather'][0]['main']]
    temp_for << [days[index], day['temp']['day'] - 272.15]
  end
  freq = weather_for.map {|day| day[1]}.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
  most_freq_weather = freq.max_by{|k,v| v}[0]

  # Report creation
  report = "The weather is mostly #{most_freq_weather} in #{location} for the next 4 days.\n"
  # If there are particular weather days
  other_weathers = weather_for.reject { |day| day[1] == most_freq_weather}
  report += "Except on #{other_weathers.map { |day| "#{day[0]}(#{day[1]})" }.join(", ")}.\n" if other_weathers.any?
  #tempreatures
  report += "The temperature will be:\n#{temp_for.map {|day| "- #{day[1].round}˚C for #{day[0]}"}.join("\n")}"
  {mostly: most_freq_weather, temps: temp_for, report: report}
end

p fetch_weather("What is the weather in Tokyo?")[:report]
