# LINE Bot 101

[日本語ドキュメント](README.ja.md)

## What we use
- [LINE Messaging API](https://developers.line.me/en/docs/messaging-api/)
- Heroku

## NOTION!
DO NOT INCLUDE 'line' in the name of provider and channel.
If you do so, you cannnot create the provider nor the channel.

## Installation
```
$ git clone https://github.com/hidehiro98/line-bot-101.git
$ cd line-bot-101

$ brew install heroku/brew/heroku
$ heroku create $YOUR_APP_NAME

$ heroku config:set LINE_CHANNEL_SECRET=$YOUR_CHANNEL_SECRET
$ heroku config:set LINE_CHANNEL_TOKEN=$YOUR_CHANNEL_TOKEN
Example
$ heroku config:set LINE_CHANNEL_SECRET=f73d5df3fagu3g301856e1dc4cfcf3e1
$ heroku config:set LINE_CHANNEL_TOKEN=FbKBF7cB1HReh9lIc6M3bDz8Rd6D+0f1kvBaJF93QadC7SsGpHP9K1EOOYkbwRThXHdVSSupJ4TgKMEtE/LbnE2heif2GZci+ntGdP89cGfrbLiofFFBlrFygi58f/B5UsvqkvlfNM7BHddRZhhV2RgdB04t89/1O/w1cDnyilFU=

Only for image recognition
$ heroku config:set IBM_IAM_API_KEY=$YOUR_IAM_API_KEY

$ git push heroku master
```

## Slides
https://www.slideshare.net/HidehiroNagaoka/le-wagon-tokyo-line-bot-101

## Docs
### Docs of LINE Messagin API
- https://developers.line.me/en/docs/messaging-api/building-sample-bot-with-heroku/
- https://github.com/line/line-bot-sdk-ruby

### Docs of Sinatra
- https://devcenter.heroku.com/articles/rack#sinatra

### Docs of IBM Watson
- https://console.bluemix.net/apidocs/visual-recognition?language=ruby
- https://console.bluemix.net/dashboard/apps
