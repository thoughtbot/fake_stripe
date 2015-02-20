require 'fake_stripe/configuration'
require 'fake_stripe/initializers/webmock'
require 'fake_stripe/stub_app'
require 'fake_stripe/stub_stripe_js'

module FakeStripe
  extend Configuration

  VALID_CARD_NUMBER = '4242424242424242'

  def self.card_count
    @card_count
  end

  def self.card_count=(card_count)
    @card_count = card_count
  end

  def self.charge_count
    @charge_count
  end

  def self.charge_count=(charge_count)
    @charge_count = charge_count
  end

  def self.coupon_count
    @coupon_count
  end

  def self.coupon_count=(coupon_count)
    @coupon_count = coupon_count
  end

  def self.customer_count
    @customer_count
  end

  def self.customer_count=(customer_count)
    @customer_count = customer_count
  end

  def self.invoice_count
    @invoice_count
  end

  def self.invoice_count=(invoice_count)
    @invoice_count = invoice_count
  end

  def self.invoiceitem_count
    @invoiceitem_count
  end

  def self.invoiceitem_count=(invoiceitem_count)
    @invoiceitem_count = invoiceitem_count
  end

  def self.plan_count
    @plan_count
  end

  def self.plan_count=(plan_count)
    @plan_count = plan_count
  end

  def self.recipient_count
    @recipient_count
  end

  def self.recipient_count=(recipient_count)
    @recipient_count = recipient_count
  end

  def self.refund_count
    @refund_count
  end

  def self.refund_count=(refund_count)
    @refund_count = refund_count
  end

  def self.subscription_count
    @subscription_count
  end

  def self.subscription_count=(subscription_count)
    @subscription_count = subscription_count
  end

  def self.token_count
    @token_count
  end

  def self.token_count=(token_count)
    @token_count = token_count
  end

  def self.transfer_count
    @transfer_count
  end

  def self.transfer_count=(transfer_count)
    @transfer_count = transfer_count
  end

  def self.reset
    @card_count = 0
    @charge_count = 0
    @coupon_count = 0
    @customer_count = 0
    @invoice_count = 0
    @invoiceitem_count = 0
    @plan_count = 0
    @recipient_count = 0
    @refund_count = 0
    @subscription_count = 0
    @token_count = 0
    @transfer_count = 0
  end

  def self.stub_stripe
    Stripe.api_key = 'FAKE_STRIPE_API_KEY'
    FakeStripe.reset
    stub_request(:any, /api.stripe.com/).to_rack(FakeStripe::StubApp)
  end
end

server = FakeStripe::StubStripeJS.boot
STRIPE_JS_HOST = "http://#{server.host}:#{server.port}"
