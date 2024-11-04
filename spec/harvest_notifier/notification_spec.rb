# frozen_string_literal: true

describe HarvestNotifier::Notification do
  subject(:notification) { described_class.new(slack_double, update_url: update_url) }

  let(:slack_double) { instance_double(HarvestNotifier::Slack) }
  let(:update_url) { nil }
  let(:template_config) do
    {
      template: HarvestNotifier::Templates::Base,
      template_name: :base,
      assigns: { users: [{ email: "john.doe@example.com" }] },
      body: "Hello!"
    }
  end

  before do
    allow(template_config[:template]).to receive(:generate).with(template_config[:assigns]) { template_config[:body] }
    allow(slack_double).to receive(:post_message).with(template_config[:body])
    allow(slack_double).to receive(:update_message).with(template_config[:body], update_url) if update_url
  end

  describe "#deliver(template_name)" do
    it "generates notification text by template_name" do
      expect(template_config[:template]).to receive(:generate).with(template_config[:assigns])
      notification.deliver(template_config[:template_name], template_config[:assigns])
    end

    it "sends message to Slack" do
      expect(slack_double).to receive(:post_message).with(template_config[:body])
      notification.deliver(template_config[:template_name], template_config[:assigns])
    end

    context "with update_url passed" do
      let(:update_url) { "http://hook.slack.com" }

      it "updates message in Slack" do
        expect(slack_double).to receive(:update_message).with(template_config[:body], update_url)
        notification.deliver(template_config[:template_name], template_config[:assigns])
      end
    end
  end
end
