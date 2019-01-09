# coding: utf-8
require 'net/http'
require 'uri'
require 'json'

# You must use the same location in your REST call as you used to get your
# subscription keys. For example, if you got your subscription keys from
# westus, replace "westcentralus" in the URL below with "westus".
uri_base =
    'https://japaneast.api.cognitive.microsoft.com/vision/v2.0/analyze'

image_url =
    'https://www.akc.org/wp-content/themes/akc/component-library/assets/img/welcome.jpg'

# Replace <Subscription Key> with your valid subscription key.
subscription_key = '3459157aedf14c36b27121ea438c36aa'

uri = URI.parse(uri_base)
https = Net::HTTP.new(uri.host, uri.port)

https.use_ssl = true
req = Net::HTTP::Post.new(uri.request_uri)

# Request parameters.
params = {
  'visualFeatures': 'Categories,Description,Color',
  'details': '',
  'language': 'ja'
}.to_json

req.body = "{'url': '#{image_url}'}"
req["Content-Type"] = "application/json"
req["Ocp-Apim-Subscription-Key"] = subscription_key
req["qs"] = params
res = https.request(req)

puts "code -> #{res.code}"
puts "msg -> #{res.message}"
puts "body -> #{res.body}"
