# LINE Bot 101

## What we use
- [LINE Messaging API](https://developers.line.me/en/docs/messaging-api/)
- Heroku

## NOTION!
DO NOT INCLUDE 'line' in the name of provider and channel.
If you do so, you cannnot create the provider nor the channel.

## Installation
```
$ git clone git@github.com:hidehiro98/line-bot-101.git
$ cd line-bot-101
$ bundle install
$ heroku create $YOUR_APP_NAME

$ heroku config:set LINE_CHANNEL_SECRET=$YOUR_CHANNEL_SECRET
$ heroku config:set LINE_CHANNEL_TOKEN=$YOUR_CHANNEL_TOKEN
Example
$ heroku config:set LINE_CHANNEL_SECRET=f73d5df3fagu3g301856e1dc4cfcf3e1
$ heroku config:set LINE_CHANNEL_TOKEN=FbKBF7cB1HReh9lIc6M3bDz8Rd6D+0f1kvBaJF93QadC7SsGpHP9K1EOOYkbwRThXHdVSSupJ4TgKMEtE/LbnE2heif2GZci+ntGdP89cGfrbLiofFFBlrFygi58f/B5UsvqkvlfNM7BHddRZhhV2RgdB04t89/1O/w1cDnyilFU=

$ git push heroku master
```

## Slides


## Docs
https://developers.line.me/en/docs/messaging-api/building-sample-bot-with-heroku/
https://github.com/line/line-bot-sdk-ruby
https://devcenter.heroku.com/articles/rack#sinatra
