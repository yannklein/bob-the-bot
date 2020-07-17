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
  week_events_formatted = week_events.map {|event| "#{Date.parse(event['date']).strftime('%a, %b %e')} - #{event['name']}" }
  "There are some cool events this week:\n#{week_events_formatted.join("\n")}"
end
