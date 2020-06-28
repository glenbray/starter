# frozen_string_literal: true

require "sidekiq/web"
Sidekiq::Web.set :sessions, false

Sidekiq.configure_server do |config|
  config.redis = {url: ENV["WORKER_URL"]}
end

Sidekiq.configure_client do |config|
  config.redis = {url: ENV["WORKER_URL"]}
end
