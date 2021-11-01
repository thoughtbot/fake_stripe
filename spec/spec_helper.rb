require 'fake_stripe'
require 'pry'
require 'rspec'
require 'stripe'
require 'rack/test'

project_root = File.expand_path("..", File.dirname(__FILE__))
$LOAD_PATH << project_root
Dir.glob("spec/support/**/*.rb").each { |file| require file }

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before :each do
    Stripe.api_key = "FAKE_STRIPE_API_KEY"
    FakeStripe.stub_stripe
  end

  config.order = 'random'
end

# Do not announce that capybara is starting puma
Capybara.server = :puma, { Silent: true }
