require 'fake_stripe/configuration'
require 'fake_stripe/initializers/webmock'
require 'fake_stripe/stub_app'
require 'fake_stripe/stub_stripe_js'

module FakeStripe
  extend Configuration

  VALID_CARD_NUMBER = '4242424242424242'

  def self.charge_count
    @@charge_count
  end

  def self.charge_count=(charge_count)
    @@charge_count = charge_count
  end

  def self.refund_count
    @@refund_count
  end

  def self.refund_count=(refund_count)
    @@refund_count = refund_count
  end

  def self.customer_count
    @@customer_count
  end

  def self.customer_count=(customer_count)
    @@customer_count = customer_count
  end

  def self.reset
    @@charge_count = 0
    @@customer_count = 0
    @@refund_count = 0
  end

  def self.stub_stripe
    Stripe.api_key = 'FAKE_STRIPE_API_KEY'
    FakeStripe.reset
    stub_request(:any, /#{Stripe.api_base}/).to_rack(FakeStripe::StubApp)
  end
end

server = FakeStripe::StubStripeJS.boot
STRIPE_JS_HOST = "http://#{server.host}:#{server.port}"
