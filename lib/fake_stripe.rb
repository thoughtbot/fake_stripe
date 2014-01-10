require 'fake_stripe/configuration'
require 'fake_stripe/initializers/webmock'
require 'fake_stripe/stub_app'
require 'fake_stripe/stub_stripe_js'
require 'fake_stripe/exceptions'

if defined?(RSpec)
  require 'fake_stripe/rspec'
end

module FakeStripe
  extend Configuration

  VALID_CARD_NUMBER = '4242424242424242'
  CUSTOMER_ID = "cus_196jLbDuP1iwqH"

  def self.charges
    @@charges
  end

  def self.charges=(charges)
    @@charges = charges
  end

  def self.cards
    @@cards
  end

  def self.cards=(cards)
    @@cards = cards
  end

  def self.reset
    @@charges = []
    @@cards = []
  end

  def self.stub_stripe
    Stripe.api_key = 'FAKE_STRIPE_API_KEY'
    FakeStripe.reset
    stub_request(:any, /api.stripe.com/).to_rack(FakeStripe::StubApp)
  end
end

server = FakeStripe::StubStripeJS.boot
STRIPE_JS_HOST = "http://#{server.host}:#{server.port}"
