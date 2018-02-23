require 'bundler/setup'

require 'sinatra/base'
require 'rest-client'
require 'json'

class SlackDockerApp < Sinatra::Base

  # For GET requests, just echo everything back to the browser to confirm we're online.
  get "/*" do
    params[:splat].first
  end

  # Handle incoming POST requests!
  post "/*" do

    # For documentation on incoming webhooks see
    # https://docs.docker.com/docker-hub/webhooks/

    raw = request.body.read
    docker = JSON.parse( raw )

    # For further development purposes, let's log the incoming data.
    puts raw

    # Put Slack message together.
    slack = {
      text: "[<#{ docker['repository']['repo_url'] }|#{ docker['repository']['repo_name'] }:#{ docker['push_data']['tag'] }>] new image build complete."
    }

    # Send to Slack, then callback to Docker.
    # @see https://github.com/neonadventures/slack-docker-hub-integration/issues/5
    RestClient.post( "https://hooks.slack.com/#{ params[:splat].first }", payload: slack.to_json ) { |response, request, result, &block|
      RestClient.post( docker['callback_url'], { state: 200 === response.code ? 'success' : 'error' }.to_json, :content_type => :json )
    }

  end # Post do.
end # Class SlackDockerApp.

run SlackDockerApp
