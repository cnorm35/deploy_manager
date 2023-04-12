class Webhooks::Incoming::GithubWebhooksController < Webhooks::Incoming::WebhooksController
  def create
    Webhooks::Incoming::GithubWebhook.create(data: JSON.parse(request.body.read)).process_async
    render json: {status: "OK"}, status: :created
  end
end
