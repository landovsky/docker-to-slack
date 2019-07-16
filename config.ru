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

    slack = {text: "#{docker['data']['name']} | #{docker['data']['git_url']} >> #{docker['action']}"}

    RestClient.post("https://hooks.slack.com/#{params[:splat].first}",
                    payload: slack.to_json) { |response, _request, _result, &block|
    }
    [200]
  end
end

run SlackDockerApp
