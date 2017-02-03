

# Pushup Bot

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/e5a22d8699a64ef5a45ca1a8efbb34e3)](https://www.codacy.com/app/Omniboard/pushup-bot?utm_source=github.com&utm_medium=referral&utm_content=omniboard/pushup-bot&utm_campaign=badger)

Slackbot that reminds the team to do their periodic pushups.

## Running

The following environment variables are used:

- `FIRST_TIME_OF_DAY`: The time of day that the first pushups shall be done, including time zone. E.g. "09:25 US/Eastern"
- `PERIOD_MINUTES`: The length of the period between sets.

## Deployment

Built in Ruby. Can be deployed to Heroku or similar infrastructure.

## Development

We use RSpec to describe the functionality of the system and to ensure it meets those specifications.
