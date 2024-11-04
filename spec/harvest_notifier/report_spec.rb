# frozen_string_literal: true

describe HarvestNotifier::Report do
  subject(:report) { described_class.new(harvest, slack) }

  let(:harvest) { instance_double(HarvestNotifier::Harvest) }
  let(:slack) { instance_double(HarvestNotifier::Slack) }

  shared_context "with user data" do
    let(:users) do
      {
        john_smith: {
          "harvest_id" => 123,
          "full_name" => "John Smith",
          "email" => "john.smith@example.com",
          "weekly_capacity" => 144_000,
          "slack_id" => "U01TEST"
        },
        bill_doe: {
          "harvest_id" => 345,
          "full_name" => "Bill Doe",
          "email" => "bill.doe@example.com",
          "weekly_capacity" => 144_000,
          "slack_id" => "U02TEST"
        },
        john_doe: {
          "harvest_id" => 678,
          "full_name" => "John Doe",
          "email" => "john.doe@example.com",
          "weekly_capacity" => 144_000,
          "slack_id" => "U03TEST"
        },
        alex_gordon: {
          "harvest_id" => 567,
          "full_name" => "Alex Gordon",
          "email" => "alex.gordon@example.com",
          "weekly_capacity" => 144_000,
          "slack_id" => "U04TEST"
        }
      }
    end

    let(:harvest_users) do
      {
        "users" => [
          {
            "id" => users[:john_smith]["harvest_id"],
            "email" => users[:john_smith]["email"],
            "first_name" => "John",
            "last_name" => "Smith",
            "weekly_capacity" => users[:john_smith]["weekly_capacity"],
            "is_contractor" => false,
            "is_active" => true
          },
          {
            "id" => users[:bill_doe]["harvest_id"],
            "email" => users[:bill_doe]["email"],
            "first_name" => "Bill",
            "last_name" => "Doe",
            "weekly_capacity" => users[:bill_doe]["weekly_capacity"],
            "is_contractor" => false,
            "is_active" => true
          },
          {
            "id" => users[:john_doe]["harvest_id"],
            "email" => users[:john_doe]["email"],
            "first_name" => "John",
            "last_name" => "Doe",
            "weekly_capacity" => users[:john_doe]["weekly_capacity"],
            "is_contractor" => true,
            "is_active" => true
          },
          {
            "id" => users[:alex_gordon]["harvest_id"],
            "email" => users[:alex_gordon]["email"],
            "first_name" => "Alex",
            "last_name" => "Gordon",
            "weekly_capacity" => users[:alex_gordon]["weekly_capacity"],
            "is_contractor" => false,
            "is_active" => false
          }
        ]
      }
    end

    let(:slack_users) do
      {
        "members" => [
          {
            "id" => users[:bill_doe]["slack_id"],
            "profile" => { "email" => users[:bill_doe]["email"] }
          }
        ]
      }
    end
  end

  include_context "with user data"

  before do
    allow(harvest).to receive(:users_list) { harvest_users }
    allow(harvest).to receive(:time_report_list) { harvest_time_report }
    allow(slack).to receive(:users_list) { slack_users }
  end

  describe "#daily" do
    let(:date) { Date.new(2020, 4, 15) }
    let(:harvest_time_report) do
      {
        "results" => [
          {
            "user_id" => users[:john_smith]["harvest_id"],
            "total_hours" => 6.0
          },
          {
            "user_id" => users[:alex_gordon]["harvest_id"],
            "total_hours" => 5.0
          }
        ]
      }
    end

    it "returns Bill Doe without time reports" do
      expect(report.daily(date))
        .to include(
          include(
            email: users[:bill_doe]["email"],
            slack_id: users[:bill_doe]["slack_id"],
            full_name: users[:bill_doe]["full_name"]
          )
        )
    end

    it "does not return John Smith with time report" do
      expect(report.daily(date)).not_to include(include(email: users[:john_smith]["email"]))
    end

    it "does not return John Doe contractor" do
      expect(report.daily(date)).not_to include(include(email: users[:john_doe]["email"]))
    end

    it "does not return inactive user Alex Gordon" do
      expect(report.daily(date)).not_to include(include(email: users[:alex_gordon]["email"]))
    end
  end

  describe "#weekly" do
    let(:from) { Date.new(2020, 4, 6) }
    let(:to) { from + 4 }
    let(:harvest_time_report) do
      {
        "results" => [
          {
            "user_id" => users[:john_smith]["harvest_id"],
            "total_hours" => 35.25
          },
          {
            "user_id" => users[:bill_doe]["harvest_id"],
            "total_hours" => 39.00
          },
          {
            "user_id" => users[:alex_gordon]["harvest_id"],
            "total_hours" => 5.0
          }
        ]
      }
    end

    it "returns array of users" do
      expect(report.weekly(from, to)).to be_a(Array)
    end

    it "returns John Smith with missing 5 hours and empty Slack id" do
      expect(report.weekly(from, to))
        .to include(
          include(
            email: users[:john_smith]["email"],
            missing_hours: 4.75,
            full_name: users[:john_smith]["full_name"]
          )
        )
    end

    it "does not return John Doe contractor" do
      expect(report.weekly(from, to)).not_to include(include(email: users[:john_doe]["email"]))
    end

    it "does not return Bill Doe with missing 1 hour b/c of threshold default 1.0 hour" do
      expect(report.weekly).not_to include(include(email: users[:bill_doe]["email"]))
    end

    it "does not return inactive user Alex Gordon" do
      expect(report.weekly).not_to include(include(email: users[:alex_gordon]["email"]))
    end
  end
end
