# frozen_string_literal: true

require "sidekiq/web"

Sidekiq.configure_server do |config|
  config.redis = {url: ENV["WORKER_URL"]}
end

Sidekiq.configure_client do |config|
  config.redis = {url: ENV["WORKER_URL"]}
end

schedule_file = "config/sidekiq_schedule.yml"

if File.exist?(schedule_file)
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end
