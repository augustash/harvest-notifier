# frozen_string_literal: true

require "httparty"

module HarvestNotifier
  class Slack
    include HTTParty

    base_uri "https://slack.com/api"
    headers "Content-type" => "application/json"
    logger ::Logger.new $stdout

    def initialize(token)
      self.class.headers "Authorization" => "Bearer #{token}"
    end

    def post_message(body)
      self.class.post("/chat.postMessage", body: body)
    end

    def update_message(body, update_url)
      self.class.post(update_url, body: body)
    end

    def users_list
      self.class.get("/users.list")
    end
  end
end
