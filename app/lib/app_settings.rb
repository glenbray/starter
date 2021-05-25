# frozen_string_literal: true

class AppSettings
  class << self
    def aws_access_key_id
      @aws_access_key_id ||= credentials(:aws_access_key_id) || ENV["AWS_ACCESS_KEY_ID"]
    end

    def aws_secret_access_key
      @aws_secret_access_key ||= begin
        secret = credentials(:aws_secret_access_key)
        secret || ENV["AWS_SECRET_ACCESS_KEY"]
      end
    end

    def aws_bucket
      @bucket ||= credentials(:aws_bucket) || ENV["AWS_BUCKET"]
    end

    def aws_region
      @aws_region ||= credentials(:aws_region) || ENV["AWS_REGION"]
    end

    def aws_endpoint
      @aws_endpoint ||= ENV["AWS_ENDPOINT"]
    end

    private

    def credentials(key)
      Rails.application.credentials.send(key.to_sym)
    end
  end
end
