class CreateWebhooksIncomingGithubWebhooks < ActiveRecord::Migration[7.0]
  def change
    create_table :webhooks_incoming_github_webhooks do |t|
      t.jsonb :data
      t.datetime :processed_at
      t.datetime :verified_at

      t.timestamps
    end
  end
end
