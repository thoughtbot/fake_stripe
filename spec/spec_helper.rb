require 'fake_stripe'
require 'pry'
require 'rspec'
require 'stripe'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before :suite do
    Stripe.api_key = 'sk_test_mkGsLqEW6SLnZa487HYfJVLf'
  end

  config.before :each do
    FakeStripe.reset!
  end

  config.order = 'random'
end
