require_relative 'boot'

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
require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsWarden
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.middleware.use Warden::Manager do |manager|
      manager.default_strategies :secret
      manager.failure_app =->(env) { [401, { "Content-Type" => "application/json" }, [{ message: "Authentication failure" }.to_json]] }
    end

    Warden::Strategies.add(:secret) do
      def authenticate!
        password = "very secret"
        req_body = JSON.parse(request.body.read)

        if req_body["secret"] == password
          user = { name: "Youtube" }
          success!(user)
        else
          fail
        end
      end
    end
  end
end
