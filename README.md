[![CircleCI](https://circleci.com/gh/omniboard/pushup-bot.svg?style=shield)](https://circleci.com/gh/omniboard/pushup-bot)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/e5a22d8699a64ef5a45ca1a8efbb34e3)](https://www.codacy.com/app/Omniboard/pushup-bot?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=omniboard/pushup-bot&amp;utm_campaign=Badge_Grade)
[![Test Coverage](https://api.codacy.com/project/badge/Coverage/e5a22d8699a64ef5a45ca1a8efbb34e3)](https://www.codacy.com/app/Omniboard/pushup-bot?utm_source=github.com&utm_medium=referral&utm_content=omniboard/pushup-bot&utm_campaign=Badge_Coverage)
[![Dependency Status](https://gemnasium.com/badges/github.com/omniboard/pushup-bot.svg)](https://gemnasium.com/github.com/omniboard/pushup-bot)

# Pushup Bot

Slackbot that reminds the team to do their periodic pushups.

![pushupbot: @channel time for pushups! Next pushups in 60 minutes.](.images/pushupbot-in-action.png "pushup-bot in action")

## Running

The following environment variables are used:

- `START_TIME`: The time of day that the first pushups shall be done, including time zone. E.g. "09:25 US/Eastern"
- `PERIOD_MINUTES`: The length of the period between sets.
- `END_TIME`: No notices will be posted at or after this time.
- `ACTIVE_WEEKDAYS`: List of weekdays that notices will be sent. Default is "MTWRF", possible values "MTWRFSU".
- `SLACK_API_TOKEN`
- `SLACK_CHANNEL`

## Deployment

Built in Ruby. Can be deployed to Heroku or similar infrastructure.

## Development

We use RSpec to describe the functionality of the system and to ensure it meets those specifications.
