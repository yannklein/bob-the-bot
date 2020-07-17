# app.rb
require "sinatra"
require "json"
require "net/http"
require "uri"
require "tempfile"

require "line/bot"
require "ibm_watson/visual_recognition_v3"

include IBMWatson

def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_token = ENV["LINE_ACCESS_TOKEN"]
  }
end

def bot_answer_to(a_question, user_name)
  return "" unless a_question.downcase.include?("bob")

  if a_question.match?(/(Hi|Hey|Bonjour|Hi there|Hey there|Hello).*/i)
    "Hello " + user_name + ", how are you doing today?"
  elsif a_question.match?(/([\p{Hiragana}\p{Katakana}\p{Han}]+)/)
    bot_jp_answer_to(a_question, user_name)
  elsif a_question.match?(/how\s+.*are\s+.*you.*/i)
    "I am fine, " + user_name
  elsif a_question.match?(/.*le wagon.*/i)
    "Wait " + user_name + "... did you mean Le Wagon Kyoto!? These guys are just great!"
  elsif a_question.end_with?('?')
    "Good question, " + user_name + "!"
  else
    ["I couldn't agree more.", "Great to hear that.", "Kinda make sense."].sample
  end
end

def bot_jp_answer_to(a_question, user_name)
  if a_question.match?(/(おはよう|こんにちは|こんばんは|ヤッホー|ハロー).*/)
    "こんにちは#{user_name}さん！お元気ですか?"
  elsif a_question.match?(/.*元気.*(？|\?｜か)/)
    "私は元気です、#{user_name}さん"
  elsif a_question.match?(/.*(le wagon|ワゴン|バゴン).*/i)
    "#{user_name}さん... もしかして京都のLE WAGONプログラミング学校の話ですかね？ 素敵な画っこと思います！"
  elsif a_question.end_with?('?','？')
    "いい質問ですね、#{user_name}さん！"
  else
    ["そうですね！", "確かに！", "間違い無いですね！"].sample
  end
end

def send_bot_message(message, client, event)
  message = { type: "text", text: message }
  client.reply_message(event["replyToken"], message)

  # Log prints
  p 'Bot message sent!'
  p event["replyToken"]
  p message
  p client
end

post "/callback" do
  body = request.body.read

  signature = request.env["HTTP_X_LINE_SIGNATURE"]
  unless client.validate_signature(body, signature)
    error 400 do "Bad Request" end
  end

  events = client.parse_events_from(body)
  events.each { |event|
    p event
    # Focus on the message events (including text, image, emoji, vocal.. messages)
    return if event.class != Line::Bot::Event::Message

    case event.type
    # when receive a text message
    when Line::Bot::Event::MessageType::Text
      user_name = ""
      user_id = event["source"]["userId"]
      response = client.get_profile(user_id)
      if response == Net::HTTPSuccess
        contact = JSON.parse(response.body)
        p contact
        user_name = contact["displayName"]
      else
        # Can't retrieve the contact info
        p "#{response.code} #{response.body}"
      end

      # The answer mecanism is here!
      send_bot_message(
        bot_answer_to(event.message["text"], user_name),
        client,
        event
      )
    # when receive an image message
    when Line::Bot::Event::MessageType::Image
      response_image = client.get_message_content(event.message["id"])
      tf = Tempfile.open
      tf.write(response_image.body)
      # Using IBM Watson visual recognition API
      visual_recognition = VisualRecognitionV3.new(
        version: "2018-03-19",
        iam_apikey: ENV["IBM_IAM_API_KEY"]
      )
      image_results = ""
      File.open(tf.path) do |images_file|
        classes = visual_recognition.classify(
          images_file: images_file,
          threshold: "0.6"
        )
        image_results = classes.result["images"][0]["classifiers"][0]["classes"]
        image_results = image_results.map {|result| result["class"].upcase}
      end
      # Sending the image results
      send_bot_message(
        "Looking at that picture, the first words that come to me are #{image_results[0..1].join(", ")} and #{image_results[2]}. Am I correct?",
        client,
        event
      )
      tf.unlink
    end
  }
end
