# frozen_string_literal: true

s3_options = {
  access_key_id: AppSettings.aws_access_key_id,
  secret_access_key: AppSettings.aws_secret_access_key,
  region: AppSettings.aws_region
}

if Rails.env.development? || Rails.env.test?
  s3_options[:force_path_style] = true
  s3_options[:endpoint] = AppSettings.aws_endpoint
end

Aws.config.update(s3_options)
