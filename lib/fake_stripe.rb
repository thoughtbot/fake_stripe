require 'fake_stripe/configuration'
require 'fake_stripe/exceptions'
require 'fake_stripe/initializers/webmock'
require 'fake_stripe/models'
require 'fake_stripe/stub_app'
require 'fake_stripe/stub_stripe_js'

if defined?(RSpec)
  require 'fake_stripe/rspec'
end

module FakeStripe
  extend Configuration

  VALID_CARD_NUMBER = '4242424242424242'
  CUSTOMER_ID = "cus_196jLbDuP1iwqH"

  class << self
    attr_accessor :charges
    attr_accessor :customer_cards
  end

  def self.cards
    customer_cards.values
  end

  def self.card_ids
    customer_cards.keys
  end

  def self.reset
    self.charges = []
    self.customer_cards = {}
  end

  def self.stub_stripe
    Stripe.api_key = 'FAKE_STRIPE_API_KEY'
    FakeStripe.reset
    stub_request(:any, /api.stripe.com/).to_rack(FakeStripe::StubApp)
  end
end

server = FakeStripe::StubStripeJS.boot
STRIPE_JS_HOST = "http://#{server.host}:#{server.port}"
