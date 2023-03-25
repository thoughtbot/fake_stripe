require 'spec_helper'

describe 'Stub app' do
  include Rack::Test::Methods

  TESTS = {
    # Charges
    'POST charges' => { route: '/v1/charges', method: :post },
    'GET charges/:charge_id' => { route: '/v1/charges/1', method: :get },
    'POST charges/:charge_id' => { route: '/v1/charges/1', method: :post },
    'POST refunds' => { route: '/v1/refunds', method: :post },
    'POST charges/:charge_id/refund' =>
    { route: '/v1/charges/1/refund', method: :post },
    'POST charges/:charge_id/capture' =>
      { route: '/v1/charges/1/capture', method: :post },
    'GET charges' => { route: '/v1/charges', method: :get },
    # PaymentIntents
    'POST payment_intents' => { route: '/v1/payment_intents', method: :post },
    'GET payment_intents/:payment_intent_id' => { route: '/v1/payment_intents/1', method: :get },
    'POST payment_intents/:payment_intent_id' => { route: '/v1/payment_intents/1', method: :post },
    'POST payment_intents/:payment_intent_id/confirm' => { route: '/v1/payment_intents/1/confirm', method: :post },
    # Customers
    'POST customers' => { route: '/v1/customers', method: :post },
    'GET customers/:customer_id' => { route: '/v1/customers/1', method: :get },
    'POST customers/:customer_id' =>
       { route: '/v1/customers/1', method: :post },
    'DELETE customers/:customer_id' =>
       { route: '/v1/customers/1', method: :delete },
    'GET customers' => { route: '/v1/customers', method: :get },
    # Cards
    'POST customers/:customer_id/sources' =>
       { route: '/v1/customers/1/sources', method: :post },
    'GET customers/:customer_id/sources/:card_id' =>
       { route: '/v1/customers/1/sources/1', method: :get },
    'POST customers/:customer_id/sources/:card_id' =>
       { route: '/v1/customers/1/sources/1', method: :post },
    'DELETE customers/:customer_id/sources/:card_id' =>
       { route: '/v1/customers/1/sources/1', method: :delete },
    'GET customers/:customer_id/sources' =>
       { route: '/v1/customers/1/sources', method: :get },
    # Subscriptions
    'POST customers/:customer_id/subscriptions' =>
       { route: '/v1/customers/1/subscriptions', method: :post },
    'GET customers/:customer_id/subscriptions/:subscription_id' =>
       { route: '/v1/customers/1/subscriptions/1', method: :get },
    'POST customers/:customer_id/subscriptions/:subscription_id' =>
       { route: '/v1/customers/1/subscriptions/1', method: :post },
    'DELETE customers/:customer_id/subscriptions/:subscription_id' =>
       { route: '/v1/customers/1/subscriptions/1', method: :delete },
    'GET customers/:customer_id/subscriptions' =>
       { route: '/v1/customers/1/subscriptions', method: :get },

    'GET subscriptions/:subscription_id' =>
       { route: '/v1/subscriptions/1', method: :get },
    'POST subscriptions/:subscription_id' =>
       { route: '/v1/subscriptions/1', method: :post },
    'POST subscriptions' =>
       { route: '/v1/subscriptions', method: :post },

    # Plans
    'POST plans' => { route: '/v1/plans', method: :post },
    'GET plans/:plan_id' => { route: '/v1/plans/1', method: :get },
    'POST plans/:plan_id' => { route: '/v1/plans/1', method: :post },
    'DELETE plans/:plan_id' => { route: '/v1/plans/1', method: :delete },
    'GET plans' => { route: '/v1/plans', method: :get },
    # Coupons
    'POST coupons' => { route: '/v1/coupons', method: :post },
    'GET coupons/:coupon_id' => { route: '/v1/coupons/1', method: :get },
    'DELETE coupons/:coupon_id' => { route: '/v1/coupons/1', method: :delete },
    'GET coupons' => { route: '/v1/coupons', method: :get },
    # Discounts
    'DELETE customers/:customer_id.discount' =>
       { route: '/v1/customers/1/discount', method: :delete },
    'DELETE customers/:customer_id/subscriptions/:subscription_id/discount' =>
       { route: '/v1/customers/1/subscriptions/1/discount', method: :delete },
    # Invoices
    'GET invoices/:invoice_id' => { route: '/v1/invoices/1', method: :get },
    'GET invoices/:invoice_id/lines' =>
       { route: '/v1/invoices/1/lines', method: :get },
    'POST invoices' => { route: '/v1/invoices', method: :post },
    'POST invoices/:invoice_id/pay' =>
       { route: '/v1/invoices/1/pay', method: :post },
    'POST invoices/:invoice_id' => { route: '/v1/invoices/1', method: :post },
    'GET invoices' => { route: '/v1/invoices', method: :get },
    'GET invoices/upcoming' => { route: '/v1/invoices/upcoming', method: :get },
    # Invoice Items
    'POST invoiceitems' => { route: '/v1/invoiceitems', method: :post },
    'GET invoiceitems/:invoiceitem_id' =>
       { route: '/v1/invoiceitems/1', method: :get },
    'POST invoiceitems/:invoiceitem_id' =>
       { route: '/v1/invoiceitems/1', method: :post },
    'DELETE invoiceitems/:invoiceitem_id' =>
       { route: '/v1/invoiceitems/1', method: :delete },
    'GET invoiceitems' => { route: '/v1/invoiceitems', method: :get },
    # Disputes
    'POST charges/:charge_id/dispute' =>
       { route: '/v1/charges/1/dispute', method: :post },
    'POST charges/:charge_id/dispute/close' =>
       { route: '/v1/charges/1/dispute/close', method: :post },
    # Transfers
    'POST transfers' => { route: '/v1/transfers', method: :post },
    'GET transfers/:transfer_id' => { route: '/v1/transfers/1', method: :get },
    'POST transfers/:transfer_id' =>
       { route: '/v1/transfers/1', method: :post },
    'POST transfers/:transfer_id/cancel' =>
       { route: '/v1/transfers/1/cancel', method: :post },
    'GET transfers' => { route: '/v1/transfers', method: :get },
    # Recipients
    'POST recipients' => { route: '/v1/recipients', method: :post },
    'GET recipients/:recipient_id' =>
       { route: '/v1/recipients/1', method: :get },
    'POST recipients/:recipient_id' =>
       { route: '/v1/recipients/1', method: :post },
    'DELETE recipients/:recipient_id' =>
       { route: '/v1/recipients/1', method: :delete },
    'GET recipients' => { route: '/v1/recipients', method: :get },
    # Application Fees
    'GET application_fees/:fee_id' =>
       { route: '/v1/application_fees/1', method: :get },
    'POST application_fees/:fee_id' =>
       { route: '/v1/application_fees/1/refund', method: :post },
    'GET application_fees' => { route: '/v1/application_fees', method: :get },
    # Accounts
    'GET account' => { route: '/v1/account', method: :get },
    # Balance
    'GET balance' => { route: '/v1/balance', method: :get },
    'GET balance/history/:transaction_id' =>
       { route: '/v1/balance/history/1', method: :get },
    'GET balance/history' => { route: '/v1/balance/history', method: :get },
    # Events
    'GET events/:event_id' => { route: '/v1/events/1', method: :get },
    'GET events' => { route: '/v1/events', method: :get },
    # Tokens
    'POST tokens' => { route: '/v1/tokens', method: :post },
    'GET tokens/:token_id' => { route: '/v1/tokens/1', method: :get }
  }

  TESTS.each_pair do |name, action|
    describe name do
      it 'returns valid json' do
        send action[:method], action[:route]

        expect { JSON.parse(last_response.body) }.not_to raise_error
      end
    end
  end

  def app
    FakeStripe::StubApp.new
  end
end
