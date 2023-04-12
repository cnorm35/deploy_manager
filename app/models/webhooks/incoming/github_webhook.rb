class Webhooks::Incoming::GithubWebhook < ApplicationRecord
  include Webhooks::Incoming::Webhook
  include Rails.application.routes.url_helpers

  # You can implement your authenticity verification logic in either
  # the newly scaffolded model or controller for your incoming webhooks.
  def verify_authenticity
    true
  end

  def process
  end
end
