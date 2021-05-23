require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PrototypeSnowboardingMountainResortGame
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end

STDOUT.sync = true

unless ENV['SKIP_GOOGLE_CLOUD_STORAGE'] == '1' # skip during assets:precompile
  require 'google/cloud/storage'

  credentials =
    if ENV['CREDENTIALS_JSON']
      JSON.parse(ENV['CREDENTIALS_JSON'])
    else
      'devs-sandbox-5941dd8999bb.json'
    end
  storage = Google::Cloud::Storage.new(
    project_id: 'devs-sandbox',
    credentials: credentials,
  )

  bucket = storage.bucket('prototype-snowboarding-mountain-resort-game')

  file = bucket.file("#{Rails.env}.sqlite3")
  file.download("db/#{Rails.env}.sqlite3")
end
