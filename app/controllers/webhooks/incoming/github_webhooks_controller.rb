class Webhooks::Incoming::GithubWebhooksController < Webhooks::Incoming::WebhooksController
  def create
    Webhooks::Incoming::GithubWebhook.create(data: parsed_body).process_async
    app_id = Rails.application.credentials.dig(:hatchbox, :app_id)
    hatchbox_deploy_url = "https://app.hatchbox.io/webhooks/deployments/#{app_id}?latest=true"
    deployment_id = HTTParty.post(hatchbox_deploy_url)
    puts "deployment_id: #{deployment_id}***************"

    check_url = "https://app.hatchbox.io/apps/#{app_id}/activities/#{deployment_id}"
    deploy_status = HTTParty.get(check_url)
    # send post request
    # after create hook to deploy changes?
    render json: {status: "OK"}, status: :created
  end

  private

  def parsed_body
    JSON.parse(request.body.read)
  end
end
