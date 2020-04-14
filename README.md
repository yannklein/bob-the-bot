Built on the shoulder of giants, especially https://github.com/hidehiro98/

# LINE Bot 101

[日本語ドキュメント](README.ja.md)

## Line Bot example (scan the QR code with your Line app)
![qr code](https://github.com/YannKlein/bob-the-bot/blob/master/images/qrcode.png?raw=true)

## What we use
- [LINE Messaging API](https://developers.line.me/en/docs/messaging-api/)
- Heroku

## CAUTION!
DO NOT INCLUDE 'line' in the name of provider and channel.
If you do so, you cannnot create the provider nor the channel.

## Setup

### MacOS
#### Install Heroku
If you don't have brew, do this first
```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
Then do,
```
brew install heroku/brew/heroku
```
_Alternative option:_ install by dowloading [the Heroku Installer](https://devcenter.heroku.com/articles/heroku-cli#download-and-install).
#### Install Git
Download Git [here](https://git-scm.com/download/mac) and install it
### Ubuntu
#### Install Heroku
```
sudo snap install --classic heroku
```
#### Install Git
```
apt-get install git
```
### Windows
#### Install Heroku
Download [the Heroku Installer](https://devcenter.heroku.com/articles/heroku-cli#download-and-install) and install it.

#### Install Git
Download Git [here](https://git-scm.com/download/win) and install it

## Get the code up and running
Open a terminal (search for "Terminal" (Mac, Ubuntu) or "Command Prompt" (Windows) in your OS search bar).

We will dowload the bot code from Github, then we will push it to Heroku:
```
git clone https://github.com/yannklein/bob-the-bot.git [your-bot-name]
cd [your-bot-name]
heroku create [your-bot-name]
git push heroku master
```
We will configure the keys to access the LINE API service:

Replace `[YOUR_LINE_CHANNEL_SECRET]` and `[YOUR_LINE_ACCESS_TOKEN]` by your own keys.
```
heroku config:set LINE_CHANNEL_SECRET=[YOUR_LINE_CHANNEL_SECRET]
heroku config:set LINE_ACCESS_TOKEN=[YOUR_LINE_ACCESS_TOKEN]
```

_Example (do not copy/paste in your terminal):_
```
heroku config:set LINE_CHANNEL_SECRET=f73d5df3fagu3g301856e1dc4cfcf3e1
heroku config:set LINE_ACCESS_TOKEN=FbKBF7cB1HReh9lIc6M3bDz8Rd6D+0f1kvBaJF93QadC7SsGpHP9K1EOOYkbwRThXHdVSSupJ4TgKMEtE/LbnE2heif2GZci+ntGdP89cGfrbLiofFFBlrFygi58f/B5UsvqkvlfNM7BHddRZhhV2RgdB04t89/1O/w1cDnyilFU=
```

Optional: we will set the key for Watson image recognition:
```
heroku config:set IBM_IAM_API_KEY=[YOUR_IAM_API_KEY]
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
