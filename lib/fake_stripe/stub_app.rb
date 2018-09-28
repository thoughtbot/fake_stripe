require 'sinatra/base'

module FakeStripe
  class StubApp < Sinatra::Base

    # Charges
    post '/v1/charges' do
      if params['amount'] && params['amount'].to_i <= 0
        json_response 400, fixture('invalid_positive_integer')
      else
        charge = successful_charge
        FakeStripe.charge_calls << charge
        json_response 201, charge.to_json
      end
    end


    get '/v1/charges/:charge_id' do
      json_response 200, fixture('retrieve_charge')
    end

    post '/v1/charges/:charge_id' do
      json_response 200, fixture('update_charge')
    end

    post '/v1/refunds' do
      FakeStripe.refund_calls << {}
      json_response 200, fixture('refund_charge')
    end

    post '/v1/charges/:charge_id/refund' do
      FakeStripe.refund_calls << {}
      json_response 200, fixture('refund_charge')
    end

    post '/v1/charges/:charge_id/capture' do
      json_response 200, fixture('capture_charge')
    end

    get '/v1/charges' do
      json_response 200, fixture('list_charges')
    end

    # Customers
    post '/v1/customers' do
      FakeStripe.customer_calls << {}
      json_response 200, fixture('create_customer')
    end

    get '/v1/customers/:id' do
      json_response 200, fixture('retrieve_customer')
    end

    post '/v1/customers/:id' do
      json_response 200, fixture('update_customer')
    end

    delete '/v1/customers/:customer_id' do
      json_response 200, fixture('delete_customer')
    end

    get '/v1/customers' do
      json_response 200, fixture('list_customers')
    end

    # Cards
    post '/v1/customers/:customer_id/sources' do
      FakeStripe.card_calls << {}
      json_response 200, fixture('create_card')
    end

    get '/v1/customers/:customer_id/sources/:card_id' do
      json_response 200, fixture('retrieve_card')
    end

    post '/v1/customers/:customer_id/sources/:card_id' do
      json_response 200, fixture('update_card')
    end

    delete '/v1/customers/:customer_id/sources/:card_id' do
      json_response 200, fixture('delete_card')
    end

    get '/v1/customers/:customer_id/sources' do
      json_response 200, fixture('list_cards')
    end

    # Subscriptions
    [
      '/v1/subscriptions',
      '/v1/customers/:customer_id/subscriptions',
    ].each do |path|
      post path do
        FakeStripe.subscription_calls << {}
        json_response 200, fixture('create_subscription')
      end
    end

    [
      '/v1/subscriptions/:subscription_id',
      '/v1/customers/:customer_id/subscriptions/:subscription_id',
    ].each do |path|
      get path do
        json_response 200, fixture('retrieve_subscription')
      end
    end

    [
      '/v1/subscriptions/:subscription_id',
      '/v1/customers/:customer_id/subscriptions/:subscription_id',
    ].each do |path|
      post path do
        json_response 200, fixture('update_subscription')
      end
    end

    [
      '/v1/subscriptions/:subscription_id',
      '/v1/customers/:customer_id/subscriptions/:subscription_id',
    ].each do |path|
      delete path do
        json_response 200, fixture('cancel_subscription')
      end
    end

    [
      '/v1/subscriptions',
      '/v1/customers/:customer_id/subscriptions',
    ].each do |path|
      get path do
        json_response 200, fixture('list_subscriptions')
      end
    end

    get '/v1/subscriptions/:subscription_id' do
      json_response 200, fixture('retrieve_subscription')
    end

    post '/v1/subscriptions/:subscription_id' do
      json_response 200, fixture('retrieve_subscription')
    end

    post '/v1/subscriptions' do
      json_response 200, fixture('retrieve_subscription')
    end

    # Plans
    post '/v1/plans' do
      FakeStripe.plan_calls << {}
      json_response 200, fixture('create_plan')
    end

    get '/v1/plans/:plan_id' do
      json_response 200, fixture('retrieve_plan')
    end

    post '/v1/plans/:plan_id' do
      json_response 200, fixture('update_plan')
    end

    delete '/v1/plans/:plan_id' do
      json_response 200, fixture('delete_plan')
    end

    get '/v1/plans' do
      json_response 200, fixture('list_plans')
    end

    # Coupons
    post '/v1/coupons' do
      FakeStripe.coupon_calls << {}
      json_response 200, fixture('create_coupon')
    end

    get '/v1/coupons/:coupon_id' do
      json_response 200, fixture('retrieve_coupon')
    end

    delete '/v1/coupons/:coupon_id' do
      json_response 200, fixture('delete_coupon')
    end

    get '/v1/coupons' do
      json_response 200, fixture('list_coupons')
    end

    # Discounts
    delete '/v1/customers/:customer_id/discount' do
      json_response 200, fixture('delete_customer_discount')
    end

    delete '/v1/customers/:customer_id/subscriptions/:subscription_id/discount' do
      json_response 200, fixture('delete_subscription_discount')
    end

    # Invoices
    get '/v1/invoices/:invoice_id' do
      json_response 200, fixture('retrieve_invoice')
    end

    get '/v1/invoices/:invoice_id/lines' do
      json_response 200, fixture('retrieve_invoice_line_items')
    end

    post '/v1/invoices' do
      FakeStripe.invoice_calls << {}
      json_response 200, fixture('create_invoice')
    end

    post '/v1/invoices/:invoice_id/pay' do
      json_response 200, fixture('pay_invoice')
    end

    post '/v1/invoices/:invoice_id' do
      json_response 200, fixture('update_invoice')
    end

    get '/v1/invoices' do
      json_response 200, fixture('list_invoices')
    end

    get '/v1/invoices/upcoming' do
      json_response 200, fixture('retrieve_upcoming_invoice')
    end

    # Invoice Items
    post '/v1/invoiceitems' do
      FakeStripe.invoiceitem_calls << {}
      json_response 200, fixture('create_invoiceitem')
    end

    get '/v1/invoiceitems/:invoiceitem_id' do
      json_response 200, fixture('retrieve_invoiceitem')
    end

    post '/v1/invoiceitems/:invoiceitem_id' do
      json_response 200, fixture('update_invoiceitem')
    end

    delete '/v1/invoiceitems/:invoiceitem_id' do
      json_response 200, fixture('delete_invoiceitem')
    end

    get '/v1/invoiceitems' do
      json_response 200, fixture('list_invoiceitems')
    end

    # Disputes
    post '/v1/charges/:charge_id/dispute' do
      json_response 200, fixture('update_dispute')
    end

    post '/v1/charges/:charge_id/dispute/close' do
      json_response 200, fixture('close_dispute')
    end

    # Transfers
    post '/v1/transfers' do
      FakeStripe.transfer_calls << {}
      json_response 200, fixture('create_transfer')
    end

    get '/v1/transfers/:transfer_id' do
      json_response 200, fixture('retrieve_transfer')
    end

    post '/v1/transfers/:transfer_id' do
      json_response 200, fixture('update_transfer')
    end

    post '/v1/transfers/:transfer_id/cancel' do
      json_response 200, fixture('cancel_transfer')
    end

    get '/v1/transfers' do
      json_response 200, fixture('list_transfers')
    end

    # Recipients
    post '/v1/recipients' do
      FakeStripe.recipient_calls << {}
      json_response 200, fixture('create_recipient')
    end

    get '/v1/recipients/:recipient_id' do
      json_response 200, fixture('retrieve_recipient')
    end

    post '/v1/recipients/:recipient_id' do
      json_response 200, fixture('update_recipient')
    end

    delete '/v1/recipients/:recipient_id' do
      json_response 200, fixture('delete_recipient')
    end

    get '/v1/recipients' do
      json_response 200, fixture('list_recipients')
    end

    # Application Fees
    get '/v1/application_fees/:fee_id' do
      json_response 200, fixture('retrieve_application_fee')
    end

    post '/v1/application_fees/:fee_id/refund' do
      json_response 200, fixture('refund_application_fee')
    end

    get '/v1/application_fees' do
      json_response 200, fixture('list_application_fees')
    end

    # Accounts
    get '/v1/account' do
      json_response 200, fixture('retrieve_account')
    end

    get '/v1/accounts/:account_id' do
      json_response 200, fixture('retrieve_account')
    end

    post "/v1/accounts" do
      json_response 201, fixture("create_account")
    end

    post "/v1/accounts/:account_id" do
      json_response 201, fixture("update_account")
    end

    # Balance
    get '/v1/balance' do
      json_response 200, fixture('retrieve_balance')
    end

    get '/v1/balance/history/:transaction_id' do
      json_response 200, fixture('retrieve_balance_transaction')
    end

    get '/v1/balance/history' do
      json_response 200, fixture('list_balance_history')
    end

    # Events
    get '/v1/events/:event_id' do
      json_response 200, fixture('retrieve_event')
    end

    get '/v1/events' do
      json_response 200, fixture('list_events')
    end

    # Tokens
    post '/v1/tokens' do
      FakeStripe.token_calls << {}
      json_response 200, fixture(token_fixture_name)
    end

    get '/v1/tokens/:token_id' do
      json_response 200, fixture('retrieve_token')
    end

    private

    def fixture(file_name)
      file_path = File.join(FakeStripe.fixture_path, "#{file_name}.json")
      File.open(file_path, 'rb').read
    end

    def json_response(response_code, response_body)
      content_type :json
      status response_code
      response_body
    end

    def token_fixture_name
      if params.has_key?(FakeStripe::BANK_ACCOUNT_OBJECT_TYPE)
        "create_bank_account_token"
      else
        "create_card_token"
      end
    end

    def successful_charge
      {
        amount: params[:amount].to_i,
        card: {
          id: params[:card],
          address_city: nil,
          address_country: nil,
          address_line1: nil,
          address_line1_check: nil,
          address_line2: nil,
          address_state: nil,
          address_zip: nil,
          address_zip_check: nil,
          country: "US",
          cvc_check: "pass",
          exp_month: 11,
          exp_year: 2014,
          fingerprint: "qhjxpr7DiCdFYTlH",
          last4: "4242",
          name: "john doe",
          object: "card",
          type: "Visa"
        },
        amount_refunded: 0,
        application_fee: nil,
        balance_transaction: "txn_17bBUd2eZvKYlo2CAv3mOn7F",
        captured: true,
        created: 11456245794,
        currency: "usd",
        customer: "cus_7xeYRmuGuwvZK1",
        description: "Charge for VirtuMedix consultation for Guy Henggeler",
        destination: nil,
        dispute: nil,
        failure_code: nil,
        failure_message: nil,
        fee: 59,
        fee_details: [
          {
            amount: 59,
            application: nil,
            currency: "usd",
            description: "Stripe processing fees",
            type: "stripe_fee"
          }
        ],
        fraud_details: {
        },

        id: "ch_17hjFm2eZvKYlo2Cf6ceKOqV",
        invoice: nil,
        livemode: false,
        metadata: {
        },
        object: "charge",
        order: nil,
        paid: true,
        refunded: false,
        refunds: {
          object: "list",
          data: [
          ],
          has_more: false,
          total_count: 0,
          url: "/v1/charges/ch_17hjFm2eZvKYlo2Cf6ceKOqV/refunds"
        },
        shipping: nil,
        source: {
          id: "card_17hjFk2eZvKYlo2CuvsYuAE1",
          object: "card",
          address_city: nil,
          address_country: nil,
          address_line1: nil,
          address_line1_check: nil,
          address_line2: nil,
          address_state: nil,
          address_zip: nil,
          address_zip_check: nil,
          brand: "Visa",
          country: "US",
          customer: "cus_7xeYRmuGuwvZK1",
          cvc_check: "pass",
          dynamic_last4: nil,
          exp_month: 2,
          exp_year: 2017,
          funding: "credit",
          last4: "4242",
          metadata: {
          },
          name: nil,
          tokenization_method: nil
        },
        statement_descriptor: nil,
        status: "succeeded"
      }
    end
  end
end
