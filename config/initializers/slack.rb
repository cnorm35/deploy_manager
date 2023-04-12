Slack.configure do |config|
  config.token = Rails.application.credentials.dig(:slack, :oauth_token)
end
