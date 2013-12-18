require 'fake_stripe/initializers/webmock'
require 'fake_stripe/api_server'
require 'fake_stripe/js_server'

module FakeStripe
  VALID_CARD_NUMBER = '4242424242424242'

  def self.charge_count
    @@charge_count
  end

  def self.charge_count=(charge_count)
    @@charge_count = charge_count
  end

  def self.fail_all_requests
    @@errors = true
  end

  def self.error_response?
    @@errors
  end

  def self.reset!
    @@charge_count = 0
    @@errors = false
  end

  def self.start_server
    FakeStripe::JsServer.boot
  end
end

server = FakeStripe.start_server
STRIPE_JS_HOST = ["http://#{server.host}", server.port].join(':')
