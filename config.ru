require 'bundler/setup'

require 'sinatra/base'
require 'rest-client'
require 'json'

class SlackDockerApp < Sinatra::Base
  get "/*" do
    params[:splat].first
  end
  post "/*" do
    docker = JSON.parse(request.body.read)

    puts docker

    slack = {text: "#{docker['data']['app']['name']} | #{docker['resource'].upcase} >> #{docker['data']['status']}"}

    RestClient.post("https://hooks.slack.com/#{params[:splat].first}",
                    slack.to_json,
                    {content_type: :json, accept: :json})
    [200]
  end
end

run SlackDockerApp
