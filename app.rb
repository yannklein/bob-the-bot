# app.rb
require 'sinatra'
require "json"
require 'tempfile'
require 'line/bot'
require "ibm_watson/visual_recognition_v3"
require 'aws-sdk'

include IBMWatson

def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  }
end

post '/callback' do
  body = request.body.read

  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    error 400 do 'Bad Request' end
  end

  events = client.parse_events_from(body)
  events.each { |event|
    case event
    when Line::Bot::Event::Message
      case event.type
      when Line::Bot::Event::MessageType::Text
        p event
        user_id = event['source']['userId']
        user_name = ''
        response = client.get_profile(user_id)
        case response
        when Net::HTTPSuccess then
          contact = JSON.parse(response.body)
          p contact
          user_name = contact['displayName']
        else
          p "#{response.code} #{response.body}"
        end

        if event.message['text'] == 'How are you?'
          message = {
            type: 'text',
            text: "I'm fine, " + user_name
          }
          client.reply_message(event['replyToken'], message)
        else
          message = {
            type: 'text',
            text: event.message['text'] + ', ' + user_name
          }
          client.reply_message(event['replyToken'], message)
        end

      # when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
      when Line::Bot::Event::MessageType::Image
        response = client.get_message_content(event.message['id'])
        tf = Tempfile.open
        tf.write(response.body)

        # Using IBM Watson
        # visual_recognition = VisualRecognitionV3.new(
        #   version: "2018-03-19",
        #   iam_apikey: ENV["IBM_IAM_API_KEY"]
        # )

        # image_result = ''
        # File.open(tf.path) do |images_file|
        #   classes = visual_recognition.classify(
        #     images_file: images_file,
        #     threshold: "0.6"
        #   )
        #   image_result = p classes.result['images'][0]['classifiers'][0]['classes'].to_s
        # end

        # Using Amazon Rekogition

        Aws.config.update({
          region: 'ap-northeast-1',
          credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
        })

        rekognition = Aws::Rekognition::Client.new(region: Aws.config[:region], credentials: Aws.config[:credentials])

        response_detect_labels = rekognition.detect_labels(
          image: { bytes: File.read(tf.path) }
        )

        response_detect_labels.labels.each do |label|
          p " #{label.name} #{label.confidence.to_i}"
        end

        image_result = {}
        response_detect_labels.labels.each do |label|
          image_result[label.name] = label.confidence.to_i
        end

        # Sending the results
        message = {
          type: 'text',
          text: image_result.to_s
        }

        client.reply_message(event['replyToken'], message)
        tf.unlink
      end
    end
  }

  "OK"
end
