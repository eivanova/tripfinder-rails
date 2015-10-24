require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'tripfinder'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
dataset_points = File.expand_path("../../datasets/points.txt", __FILE__)
dataset_routes = File.expand_path("../../datasets/routes.txt", __FILE__)
Tripfinder.configure({:points => dataset_points, :routes => dataset_routes})

module TripfinderRails
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.generators do |g|
       g.assets = false
       g.helper = false
       g.view_specs = false
       g.test_framework = nil
    end
    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.encoding="utf-8"
    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**/*.{rb,yml}').to_s]
    config.i18n.enforce_available_locales = true
    config.i18n.available_locales = [:en, :bg]
    config.i18n.default_locale = :bg
  end
end
