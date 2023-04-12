class Webhooks::Incoming::GithubWebhooksController < Webhooks::Incoming::WebhooksController
  def create
    Webhooks::Incoming::GithubWebhook.create(data: parsed_body).process_async
    app_id = Rails.application.credentials.dig(:hatchbox, :app_id)
    hatchbox_deploy_url = "https://app.hatchbox.io/webhooks/deployments/#{app_id}?latest=true"
    deployment_id = HTTParty.post(hatchbox_deploy_url)
    puts "deployment_id: #{deployment_id}***************"

    client = Slack::Web::Client.new(token: Rails.application.credentials.dig(:slack, :oauth_token))

    client.chat_postMessage(channel: "#deployments", text: "Starting deploy for ENV at TIME")
    Octopoller.poll(wait: 60, retries: 5) do
      check_url = "https://app.hatchbox.io/apps/#{app_id}/activities/#{deployment_id['id']}"
      deploy_status = HTTParty.get(check_url)
      if deploy_status['state'] == 'completed'
        puts 'should be completed'
        client.chat_postMessage(channel: "#deployments", text: "Deploy #{deploy_status['state']} at #{deploy_status['completed_at']}")
      else
        puts 'retrying'
        :re_poll
      end
    end


    render json: {status: "OK"}, status: :created
  end

  private

  def parsed_body
    JSON.parse(request.body.read)
  end
end
