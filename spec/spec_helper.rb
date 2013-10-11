require 'fake_stripe'
require 'pry'
require 'rspec'
require 'stripe'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before :each do
    FakeStripe.stub_stripe
  end

  config.order = 'random'
end
