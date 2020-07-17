require 'date'
require 'json'
require 'open-uri'

def fetch_tokyo_events
  url = "https://tokyo-events.herokuapp.com/api"
  begin
    data_serialized = open(url).read
  rescue OpenURI::HTTPError => e
    return "No events found in Tokyo..."
  end
  data = JSON.parse(data_serialized)
  # Only keep the events of the week and sort'em
  week_events = data.reject {|event| Date.parse(event['date']) - Date.today > 7 }.sort_by {|event| event['date']}
  week_events_hash = Hash.new("")
  week_events.each do |event|
    date = Date.parse(event['date']).strftime('%a, %b %e')
    week_events_hash[date] += "#{event['name']}"
  end

  answer = "There are some cool events this week:"
  week_events_hash.each do |key, value|
    answer += "\n\n- #{key}\n#{value}"
  end
  answer
end
