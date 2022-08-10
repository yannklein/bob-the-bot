Built on the shoulder of giants, especially https://github.com/hidehiro98/

# LINE Bot 101

[日本語ドキュメント](README.ja.md)

## Line Bot example (scan the QR code with your Line app)
![qr code](https://github.com/YannKlein/bob-the-bot/blob/master/images/qrcode.png?raw=true)

## What we use
- [LINE Messaging API](https://developers.line.me/en/docs/messaging-api/)
- [Heroku](https://www.heroku.com)

## Slides
- This covers the Line configuration, step by step.
- [Slides Link](line_chatbot_v3.pdf)

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

*ANYTHING INSIDE OF [ ] NEEDS TO BE CHANGED*

We will dowload the bot code from Github, then we will push it to Heroku:
```
git clone https://github.com/lewagonjapan/bob-the-bot.git [CHANGE_THIS_TO_YOUR_BOT_NAME]
cd [CHANGE_THIS_TO_YOUR_BOT_NAME]
heroku login
heroku create [CHANGE_THIS_TO_YOUR_BOT_NAME]
git push heroku master
```
We will configure the keys to access the LINE API service:

Replace `[CHANGE_THIS_TO_YOUR_LINE_CHANNEL_SECRET]` and `[CHANGE_THIS_TO_YOUR_LINE_ACCESS_TOKEN]` with your own keys.
```
heroku config:set LINE_CHANNEL_SECRET=[CHANGE_THIS_TO_YOUR_LINE_CHANNEL_SECRET]
heroku config:set LINE_ACCESS_TOKEN=[CHANGE_THIS_TO_YOUR_LINE_ACCESS_TOKEN]
```

_Example (do not copy/paste in your terminal):_
```
heroku config:set LINE_CHANNEL_SECRET=f73d5df3fagu3g301856e1dc4cfcf3e1
heroku config:set LINE_ACCESS_TOKEN=FbKBF7cB1HReh9lIc6M3bDz8Rd6D+0f1kvBaJF93QadC7SsGpHP9K1EOOYkbwRThXHdVSSupJ4TgKMEtE/LbnE2heif2GZci+ntGdP89cGfrbLiofFFBlrFygi58f/B5UsvqkvlfNM7BHddRZhhV2RgdB04t89/1O/w1cDnyilFU=
```

Optional: we will set the key for weather forecast and image recognition:

Register and get the keys:
- Weather forecast: https://home.openweathermap.org/api_keys
- Image recognition: https://imagga.com/profile/dashboard

```
heroku config:set WEATHER_API=[CHANGE_THIS_TO_YOUR_WEATHER_API_KEY]
heroku config:set IMAGGA_KEY=[CHANGE_THIS_TO_YOUR_IMAGGA_API_KEY]
heroku config:set IMAGGA_SECRET=[CHANGE_THIS_TO_YOUR_IMAGGA_API_SECRET]
```
## Ready to Upgrade? Making Changes to your Bot
- Make your changes in your text editor 
- You can download [ Sublime Text](https://www.sublimetext.com/) or [VS code](https://code.visualstudio.com/) if you don't have one.
- Commit your changes and send them to Heroku:
```
git add .
git commit -m "DESCRIBE WHAT CHANGES YOU MADE"
git push heroku master
```
- When it's finished pushing, message you bot to test it out!

## Have Errors?
- In Terminal, you can run
```
heroku logs
```
- This will give you the server log. Big challenge to find that bug! 🐛

## Docs
### Docs of LINE Messagin API
- https://developers.line.me/en/docs/messaging-api/building-sample-bot-with-heroku/
- https://github.com/line/line-bot-sdk-ruby

### Docs of Sinatra
- https://devcenter.heroku.com/articles/rack#sinatra

### Docs of OpenWeather API
- https://openweathermap.org/api

### Docs of Imagga image recognition
- https://docs.imagga.com/?ruby#getting-started

## Contributors
- [hidehiro98](https://github.com/hidehiro98/)
- [yannklein](https://github.com/yannklein/)
- [dmbf29](https://github.com/dmbf29/)
