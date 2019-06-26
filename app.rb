# app.rb
require "sinatra"
require "json"
require "net/http"
require "uri"
require "tempfile"

require "line/bot"
require "ibm_watson/visual_recognition_v3"
require "aws-sdk"
require "google/apis/vision_v1"

include IBMWatson

def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_token = ENV["LINE_ACCESS_TOKEN"]
  }
end

post "/callback" do
  body = request.body.read

  signature = request.env["HTTP_X_LINE_SIGNATURE"]
  unless client.validate_signature(body, signature)
    error 400 do "Bad Request" end
  end

  events = client.parse_events_from(body)
  events.each { |event|
    case event
    when Line::Bot::Event::Message
      case event.type
      when Line::Bot::Event::MessageType::Text
        p event
        user_id = event["source"]["userId"]
        user_name = ""

        response = client.get_profile(user_id)
        case response
        when Net::HTTPSuccess then
          contact = JSON.parse(response.body)
          p contact
          user_name = contact["displayName"]
        else
          p "#{response.code} #{response.body}"
        end

        if event.message["text"].match?(/(Hi|Hey|Bonjour|Hi there|Hey there|Hello).*/i)
          message = {
            type: "text",
            text: "Hello " + user_name + ", how are you doing today?"
          }
          client.reply_message(event["replyToken"], message)
        elsif event.message["text"].match?(/how\s+.*are\s+.*you.*/i)
          message = {
            type: "text",
            text: "I am fine, " + user_name
          }
          client.reply_message(event["replyToken"], message)
        elsif event.message["text"].match?(/.*le wagon.*/i)
          message = {
            type: "text",
            text: "Wait " + user_name + ", you want to know about Le Wagon Kyoto? These guys are great!"
          }
          client.reply_message(event["replyToken"], message)
        elsif event.message["text"].end_with?('?')
          message = {
            type: "text",
            text: "Good question, " + user_name + "!"
          }
          client.reply_message(event["replyToken"], message)
        else
          message = {
            type: "text",
            text: "Happy to hear that " + user_name
          }
          client.reply_message(event["replyToken"], message)
        end
        p 'One more message!'
        p event["replyToken"]
        p message
        p client

      # when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
      when Line::Bot::Event::MessageType::Image
        response_image = client.get_message_content(event.message["id"])
        tf = Tempfile.open
        tf.write(response_image.body)

        # Using IBM Watson
        visual_recognition = VisualRecognitionV3.new(
          version: "2018-03-19",
          iam_apikey: ENV["IBM_IAM_API_KEY"]
        )

        image_result = ""
        File.open(tf.path) do |images_file|
          classes = visual_recognition.classify(
            images_file: images_file,
            threshold: "0.6"
          )
          image_result = p classes.result["images"][0]["classifiers"][0]["classes"].to_s
        end


        # Using Amazon Rekogition
        # Aws.config.update({
        #   region: "ap-northeast-1",
        #   credentials: Aws::Credentials.new(ENV["AWS_ACCESS_KEY_ID"], ENV["AWS_SECRET_ACCESS_KEY"])
        # })

        # rekognition = Aws::Rekognition::Client.new(region: Aws.config[:region], credentials: Aws.config[:credentials])

        # response_detect_labels = rekognition.detect_labels(
        #   image: { bytes: File.read(tf.path) }
        # )

        # response_detect_labels.labels.each do |label|
        #   p " #{label.name} #{label.confidence.to_i}"
        # end

        # image_result = {}
        # response_detect_labels.labels.each do |label|
        #   image_result[label.name] = label.confidence.to_i
        # end

        # response_detect_faces = rekognition.detect_faces({
        #   image: { bytes: File.read(tf.path) },
        #   attributes: ["ALL"]
        # })

        # if response_detect_faces.face_details[0]
        #   response_detect_faces.face_details[0].emotions.each do |emotion|
        #     image_result[emotion.type] = emotion.confidence.to_i.to_s
        #   end
        #   value = response_detect_faces.face_details[0].eyes_open.value
        #   confidence = response_detect_faces.face_details[0].eyes_open.confidence
        #   image_result['eyes_open'] = "#{value}, #{confidence}"
        # end


        # Using Cloud Vision API | Google Cloud
        # cloud_vision = Google::Apis::VisionV1::VisionService.new
        # cloud_vision.key = ENV["GOOGLE_CLOUD_VISION_API_KEY"]

        # request = Google::Apis::VisionV1::BatchAnnotateImagesRequest.new(
        #   requests: [
        #     {
        #       image:{
        #         content: File.read(tf.path)
        #       },
        #       features: [
        #         {
        #           type: "LABEL_DETECTION",
        #           maxResults: 3
        #         },
        #         {
        #           type: "IMAGE_PROPERTIES",
        #           maxResults: 3
        #         }
        #       ]
        #     }
        #   ]
        # )

        # image_result = {}
        # cloud_vision.annotate_image(request).responses[0].label_annotations.each do |entity|
        #   puts entity.description, entity.score
        #   image_result[entity.description] = entity.score
        # end


        # Using Microsoft Azure Congnitive Sevices Computer Vision
        # You must use the same location in your REST call as you used to get your
        # subscription keys. For example, if you got your subscription keys from
        # westus, replace "westcentralus" in the URL below with "westus".
        # uri_base =
        # "https://japaneast.api.cognitive.microsoft.com/vision/v2.0/analyze"

        # uri = URI.parse(uri_base)
        # https = Net::HTTP.new(uri.host, uri.port)

        # https.use_ssl = true
        # req = Net::HTTP::Post.new(uri.request_uri +
        #   "?visualFeatures=Categories,Description,Color&details=Celebrities&language=ja")

        # req["Ocp-Apim-Subscription-Key"] = ENV["AZURE_KEY"]

        # image_result = ""
        # File.open(tf.path) do |image_file|
        #   data = [["image_file", image_file]]
        #   req.set_form(data, "multipart/form-data")
        #   res = https.request(req)

        #   # Azureからのレスポンスが ASCII-8BIT なので UTF-8 にエンコードする
        #   image_result = res.body.force_encoding('UTF-8')
        # end

        # # Sending the results
        message = {
          type: "text",
          text: "I think it remind me of a #{image_result[0]["class"]} thing or maybe.. #{image_result[1]["class"]} ?? or some words liek that... let say #{image_result[2]["class"]} am I right?"
        }

        client.reply_message(event["replyToken"], message)
        tf.unlink
      end
    end
  }

  "OK"
end
