# Docker Hub build notifications for Slack

A tiny Sinatra app that receives webhooks from Docker Hub and re-posts them as Slack formatted hooks.

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

Based on [slack-docker-hub-integration](https://github.com/thomassnielsen/slack-docker-hub-integration), which itself is a fork. Thanks to both [Thomas Sunde Nielsen](https://github.com/thomassnielsen) and [Neon Adventures](https://github.com/neonadventures).

## Setup

1. Generate an incoming webhook in the Slack integration settings e.g. `https://hooks.slack.com/services/<your-service-tag…>`
2. Create a new webhook on Docker Hub with pointing to this url. e.g. `https://<your-heroku-subdomain>.herokuapp.com/services/<your-service-tag…>`

## Development

To set up for local development and testing (assuming you already have [Ruby](https://www.ruby-lang.org/en/) installed):

    git clone https://github.com/tdmalone/docker-to-slack.git
    cd docker-to-slack
    sudo gem install bundler
    bundle install

To start the server:

    rackup

Then visit http://localhost:9292/test, and confirm that it shoots 'test' back to you :).

To simulate a live notification straight into your Slack webhook:

    curl http://localhost:9292/services/<your-slack-service-tag…> --data-binary "@tests/fixtures/notification.json"

You can see what a real notification payload would look like by opening up [`notification.json`](tests/fixtures/notification.json). This comes straight from [Docker Hub's webhooks documentation](https://docs.docker.com/docker-hub/webhooks/).

Note that the `callback_url` provided is not valid, so you'll get a 404 error when running the sample. But you should still get your Slack notification!
