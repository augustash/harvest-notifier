# frozen_string_literal: true

lib_dir = File.expand_path("lib", File.dirname(__FILE__))
$LOAD_PATH << lib_dir unless $LOAD_PATH.include?(lib_dir)

require "snitcher"
require "harvest_notifier"

namespace :reports do
  desc "This task send report for the last week"
  task :weekly do
    HarvestNotifier.create_weekly_report
    Snitcher.snitch(ENV.fetch("DEADMANSSNITCH_API_KEY")) if ENV.fetch("DEADMANSSNITCH_API_KEY")
  end

  desc "This task send report for the past day"
  task :daily do
    HarvestNotifier.create_daily_report
    Snitcher.snitch(ENV.fetch("DEADMANSSNITCH_API_KEY")) if ENV.fetch("DEADMANSSNITCH_API_KEY")
  end
end
