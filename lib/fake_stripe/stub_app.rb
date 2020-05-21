require 'sinatra/base'

module FakeStripe
  class StubApp < Sinatra::Base
    # Terminal

    # Connection tokens
    post '/v1/terminal/connection_tokens' do
      FakeStripe.connection_token_count += 1
      json_response 200, fixture("create_connection_token")
    end

    # Locations
    post '/v1/terminal/locations' do
      json_response 201, fixture('create_location')
    end

    get '/v1/terminal/locations/:id' do
      json_response 201, fixture('retrieve_location')
    end

    post '/v1/terminal/locations/:id' do
      json_response 201, fixture('update_location')
    end

    delete '/v1/terminal/locations/:id' do
      json_response 201, fixture('delete_location')
    end

    get '/v1/terminal/locations' do
      json_response 201, fixture('list_locations')
    end

    # Readers
    post '/v1/terminal/readers' do
      json_response 201, fixture('create_reader')
    end

    get '/v1/terminal/readers/:id' do
      json_response 201, fixture('retrieve_reader')
    end

    post '/v1/terminal/readers/:id' do
      json_response 201, fixture('update_reader')
    end

    delete '/v1/terminal/readers/:id' do
      json_response 201, fixture('delete_reader')
    end

    get '/v1/terminal/readers' do
      json_response 201, fixture('list_readers')
    end

    # ----------------------------------------------------------------------#
    # Terminal

    # Orders
    post '/v1/orders' do
      json_response 200, fixture('create_order')
    end

    get '/v1/orders/:id' do
      json_response 200, fixture('retrieve_order')
    end

    post '/v1/orders/:id' do
      json_response 200, fixture('update_order')
    end

    post '/v1/orders/:id/returns' do
      json_response 200, fixture('return_order')
    end

    delete '/v1/orders/:id' do
      json_response 200, fixture('delete_order')
    end

    get '/v1/orders' do
      json_response 200, fixture('list_orders')
    end

    # ----------------------------------------------------------------------#

    # Charges
    post '/v1/charges' do
      FakeStripe.charge_count += 1
      json_response 201, fixture('create_charge')
    end

    get '/v1/charges/:charge_id' do
      json_response 200, fixture('retrieve_charge')
    end

    post '/v1/charges/:charge_id' do
      json_response 200, fixture('update_charge')
    end

    post '/v1/refunds' do
      FakeStripe.refund_count += 1
      json_response 200, fixture('refund_charge')
    end

    post '/v1/charges/:charge_id/refund' do
      FakeStripe.refund_count += 1
      json_response 200, fixture('refund_charge')
    end

    post '/v1/charges/:charge_id/capture' do
      json_response 200, fixture('capture_charge')
    end

    get '/v1/charges' do
      json_response 200, fixture('list_charges')
    end

    # Refunds
    get '/v1/refunds/:id' do
      json_response 200, fixture('retrieve_refund')
    end

    post '/v1/refunds/:id' do
      json_response 200, fixture('update_refund')
    end

    get '/v1/refunds' do
      json_response 200, fixture('list_refunds')
    end

    # Files
    get 'v1/files/:id' do
      json_response 200, fixture('retrieve_file')
    end

    get 'v1/files' do
      json_response 200, fixture('list_files')
    end

    # Mandates
    get 'v1/mandates/:id' do
      json_response 200, fixture('retrieve_mandate')
    end

    # Products
    post 'v1/products' do
      json_response 200, fixture('create_product')
    end

    get 'v1/products/:id' do
      json_response 200, fixture('retrieve_product')
    end

    post 'v1/products/:id' do
      json_response 200, fixture('update_product')
    end

    delete '/v1/products/:id' do
      json_response 200, fixture('delete_product')
    end

    get 'v1/products' do
      json_response 200, fixture('list_products')
    end

    # Prices
    post 'v1/prices' do
      json_response 200, fixture('create_price')
    end

    get 'v1/prices/:id' do
      json_response 200, fixture('retrieve_price')
    end

    post 'v1/prices/:id' do
      json_response 200, fixture('update_price')
    end

    get 'v1/prices' do
      json_response 200, fixture('list_prices')
    end

    # Customers
    post '/v1/customers' do
      FakeStripe.customer_count += 1
      json_response 200, fixture('create_customer')
    end

    get '/v1/customers/:id' do
      json_response 200, fixture('retrieve_customer')
    end

    post '/v1/customers/:id' do
      json_response 200, fixture('update_customer')
    end

    delete '/v1/customers/:id' do
      json_response 200, fixture('delete_customer')
    end

    get '/v1/customers' do
      json_response 200, fixture('list_customers')
    end

    # Pyment Methods
    post '/v1/payment_methods' do
      FakeStripe.payment_method_count += 1
      json_response 200, fixture('create_payment_method')
    end

    get '/v1/payment_methods/:payment_method_id' do
      json_response 200, fixture('retrieve_payment_method')
    end

    post '/v1/payment_methods/:payment_method_id' do
      json_response 200, fixture('update_payment_method')
    end

    get '/v1/payment_methods' do
      json_response 200, fixture('list_payment_methods')
    end

    post '/v1/payment_methods/:payment_method_id/attach' do
      json_response 200, fixture('attach_payment_method_to_customer')
    end

    post '/v1/payment_methods/:payment_method_id/detach' do
      json_response 200, fixture('detach_payment_method_from_customer')
    end

    # Bank Account (payment methods)
    post '/v1/customers/:customer_id/sources' do
      if params[:source]&.include?("btok")
        json_response 200, fixture('create_bank_account')
      else
        FakeStripe.card_count += 1
        json_response 200, fixture('create_card')
      end
    end

    get '/v1/bank_accounts/:id' do
      json_response 200, fixture('retrieve_bank_account')
    end

    get '/v1/customers/:customer_id/sources/:id' do
      json_response 200, fixture('retrieve_card')
    end

    # There is no way to distinguish card vs. bank with FakeStripe gem
    post '/v1/customers/:customer_id/sources/:id' do
      # json_response 200, fixture('update_bank_account')
      json_response 200, fixture('update_card')
    end

    post '/v1/customers/:customer_id/sources/:id/verify' do
      json_response 200, fixture('verify_bank_account')
    end

    # There is no way to distinguish card vs. bank with FakeStripe gem
    delete '/v1/customers/:customer_id/sources/:id' do
      # json_response 200, fixture('delete_bank_account')
      json_response 200, fixture('delete_card')
    end

    get '/v1/customers/:customer_id/sources?object=bank_account' do
      json_response 200, fixture('list_bank_accounts')
    end

    get '/v1/customers/:customer_id/sources?object=card' do
      json_response 200, fixture('list_cards')
    end

    # Source (payment method)
    post '/v1/sources' do
      json_response 200, fixture('create_source')
    end

    get '/v1/sources/:source_id' do
      json_response 200, fixture('retrieve_source')
    end

    post '/v1/sources/:source_id' do
      json_response 200, fixture('update_source')
    end

    post '/v1/customers/:customer_id/sources' do
      json_response 200, fixture('attach_source')
    end

    delete '/v1/customers/:customer_id/sources/:source_id' do
      json_response 200, fixture('detach_source')
    end

    # Subscriptions
    [
      '/v1/subscriptions',
      '/v1/customers/:customer_id/subscriptions',
    ].each do |path|
      post path do
        FakeStripe.subscription_count += 1
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

    # Susbscription Items
    post '/v1/subscription_items' do
      json_response 200, fixture('create_subscription_item')
    end

    get '/v1/subscription_items/:id' do
      json_response 200, fixture('retrieve_subscription_item')
    end

    post '/v1/subscription_items/:id' do
      json_response 200, fixture('update_subscription_item')
    end

    delete '/v1/subscription_items/:id' do
      json_response 200, fixture('delete_subscription_item')
    end

    get '/v1/subscription_items' do
      json_response 200, fixture('list_subscription_items')
    end

    # Susbscription Schedules
    post '/v1/subscription_schedules' do
      json_response 200, fixture('create_subscription_schedule')
    end

    get '/v1/subscription_schedules/:id' do
      json_response 200, fixture('retrieve_subscription_schedule')
    end

    post '/v1/subscription_schedules/:id' do
      json_response 200, fixture('update_subscription_schedule')
    end

    post '/v1/subscription_schedules/:id/cancel' do
      json_response 200, fixture('cancel_subscription_schedule')
    end

    post '/v1/subscription_schedules/:id/release' do
      json_response 200, fixture('release_subscription_schedule')
    end

    get '/v1/subscription_schedules' do
      json_response 200, fixture('list_subscription_schedules')
    end

    # Plans
    post '/v1/plans' do
      FakeStripe.plan_count += 1
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
      FakeStripe.coupon_count += 1
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

    # Credit Notes
    post '/v1/credit_notes' do
      json_response 200, fixture('create_credit_note')
    end

    get '/v1/credit_notes/:id' do
      json_response 200, fixture('retrieve_credit_note')
    end

    post '/v1/credit_notes/:id' do
      json_response 200, fixture('update_credit_note')
    end

    post '/v1/credit_notes/:id/void' do
      json_response 200, fixture('void_credit_note')
    end

    get '/v1/credit_notes' do
      json_response 200, fixture('list_credit_notes')
    end

    # Balance Transactions
    post '/v1/customers/:customer_id/balance_transactions' do
      json_response 200, fixture('create_customer_balance_transaction')
    end

    get '/v1/customers/:customer_id/balance_transactions/:balance_transaction_id' do
      json_response 200, fixture('retrieve_customer_balance_transaction')
    end

    post '/v1/customers/:customer_id/balance_transactions/:balance_transaction_id' do
      json_response 200, fixture('update_customer_balance_transaction')
    end

    get '/v1/customers/:customer_id/balance_transactions' do
      json_response 200, fixture('list_customer_balance_transactions')
    end

    # Tax IDs
    post '/v1/customers/:customer_id/tax_ids' do
      json_response 200, fixture('create_tax_id')
    end

    get '/v1/customers/:customer_id/tax_ids/:tax_id' do
      json_response 200, fixture('retrieve_tax_id')
    end

    post '/v1/customers/:customer_id/tax_ids/:tax_id' do
      json_response 200, fixture('update_tax_id')
    end

    get '/v1/customers/:customer_id/tax_ids' do
      json_response 200, fixture('list_customer_tax_ids')
    end

    # Tax Rates
    post '/v1/tax_rates' do
      json_response 200, fixture('create_tax_rate')
    end

    get '/v1/tax_rates/:id' do
      json_response 200, fixture('retrieve_tax_rate')
    end

    post '/v1/tax_rates/:id' do
      json_response 200, fixture('update_tax_rate')
    end

    get '/v1/tax_rates' do
      json_response 200, fixture('list_tax_rates')
    end

    # Discounts
    delete '/v1/customers/:customer_id/discount' do
      json_response 200, fixture('delete_customer_discount')
    end

    delete '/v1/customers/:customer_id/subscriptions/:subscription_id/discount' do
      json_response 200, fixture('delete_subscription_discount')
    end

    # Invoices
    post '/v1/invoices' do
      FakeStripe.invoice_count += 1
      json_response 200, fixture('create_invoice')
    end

    get '/v1/invoices/:invoice_id' do
      json_response 200, fixture('retrieve_invoice')
    end

    get '/v1/invoices/:invoice_id/lines' do
      json_response 200, fixture('retrieve_invoice_line_items')
    end

    post '/v1/invoices/:invoice_id/pay' do
      json_response 200, fixture('pay_invoice')
    end

    post '/v1/invoices/:invoice_id/send' do
      json_response 200, fixture('send_invoice')
    end

    post '/v1/invoices/:invoice_id' do
      json_response 200, fixture('update_invoice')
    end

    post '/v1/invoices/:invoice_id/finalize' do
      json_response 200, fixture('finalize_invoice')
    end

    post '/v1/invoices/:invoice_id/void' do
      json_response 200, fixture('void_invoice')
    end

    get '/v1/invoices' do
      json_response 200, fixture('list_invoices')
    end

    get '/v1/invoices/upcoming' do
      json_response 200, fixture('retrieve_upcoming_invoice')
    end

    get '/v1/invoices/upcoming/lines' do
      json_response 200, fixture('retrieve_upcoming_invoice_line_items')
    end

    # Invoice Items
    post '/v1/invoiceitems' do
      FakeStripe.invoiceitem_count += 1
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
    get '/v1/disputes/:id' do
      json_response 200, fixture('retrieve_dispute')
    end

    post '/v1/disputes/:id' do
      json_response 200, fixture('update_dispute')
    end

    post '/v1/disputes/:id/close' do
      json_response 200, fixture('close_dispute')
    end

    get '/v1/disputes' do
      json_response 200, fixture('list_disputes')
    end

    post '/v1/charges/:charge_id/dispute' do
      json_response 200, fixture('update_dispute')
    end

    post '/v1/charges/:charge_id/dispute/close' do
      json_response 200, fixture('close_dispute')
    end

    # Transfers
    post '/v1/transfers' do
      FakeStripe.transfer_count += 1
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
      FakeStripe.recipient_count += 1
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

    # Application Fees
    get '/v1/capabilities/:id' do
      json_response 200, fixture('retrieve_capability')
    end

    post '/v1/capabilities/:id' do
      json_response 200, fixture('update_capability')
    end

    get '/v1/accounts/:account_id/capabilities' do
      json_response 200, fixture('list_capabilities')
    end

    # External Bank/Card Accounts
    post '/v1/accounts/:account_id/external_accounts' do
      if params[:external_account]&.include?("btok")
        json_response 200, fixture('create_external_bank_account')
      else
        json_response 200, fixture('create_external_card_account')
      end
    end

    # There is no way to distinguish card vs. bank with FakeStripe gem
    get '/v1/external_accounts/:external_account_id' do
      # json_response 200, fixture('retrieve_external_bank_account')
      json_response 200, fixture('retrieve_external_card_account')
    end

    # There is no way to distinguish card vs. bank with FakeStripe gem
    post '/v1/accounts/:account_id/external_accounts/:external_account_id' do
      # json_response 200, fixture('update_external_bank_account')
      json_response 200, fixture('update_external_card_account')
    end

    # There is no way to distinguish card vs. bank with FakeStripe gem
    delete '/v1/accounts/:account_id/external_accounts/:external_account_id' do
      # json_response 200, fixture('delete_external_bank_account')
      json_response 200, fixture('delete_external_card_account')
    end

    get '/v1/accounts/:account_id/external_accounts?object=bank_account' do
      json_response 200, fixture('list_external_bank_accounts')
    end

    get '/v1/accounts/:account_id/external_accounts?object=card' do
      json_response 200, fixture('list_external_card_accounts')
    end

    # Persons
    get '/v1/accounts/:account_id/persons' do
      json_response 200, fixture('create_person')
    end

    get '/v1/accounts/:account_id/persons/:person_id' do
      json_response 200, fixture('retrieve_person')
    end

    post '/v1/accounts/:account_id/persons/:person_id' do
      json_response 200, fixture('update_person')
    end

    delete '/v1/accounts/:account_id/persons/:person_id' do
      json_response 200, fixture('delete_person')
    end

    get '/v1/accounts/:account_id/persons' do
      json_response 200, fixture('list_persons')
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

    delete "/v1/accounts/:account_id" do
      json_response 201, fixture("delete_account")
    end

    post "/v1/accounts/:account_id/reject" do
      json_response 201, fixture("reject_account")
    end

    get "/v1/accounts" do
      json_response 201, fixture("list_accounts")
    end

    # Login Link
    get '/v1/login_links' do
      json_response 200, fixture('create_login_link')
    end

    # Account Link
    get '/v1/account_links' do
      json_response 200, fixture('create_account_link')
    end

    # Application Fees
    get '/v1/application_fees/:id' do
      json_response 200, fixture('retrieve_application_fees')
    end

    # Balance
    get '/v1/balance' do
      json_response 200, fixture('retrieve_balance')
    end

    get '/v1/balance_transactions' do
      json_response 200, fixture('list_balances')
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
      FakeStripe.token_count += 1
      json_response 200, fixture(token_fixture_name)
    end

    get '/v1/tokens/:token_id' do
      json_response 200, fixture('retrieve_token')
    end

    # Payment Intents
    post '/v1/payment_intents' do
      FakeStripe.payment_intent_count += 1
      if params[:confirm]
        json_response 200, fixture("confirm_payment_intent")
      else
        json_response 200, fixture("create_payment_intent")
      end
    end

    post '/v1/payment_intents/:payment_intent_id' do
      json_response 200, fixture("retrieve_payment_intent")
    end

    post '/v1/payment_intents/:payment_intent_id/confirm' do
      json_response 200, fixture("confirm_payment_intent")
    end

    post '/v1/payment_intents/:payment_intent_id/capture' do
      json_response 200, fixture("capture_payment_intent")
    end

    # Setup Intents
    post '/v1/setup_intents' do
      if params[:payment_method].present?
        # succeeded with attached payment_method and customer
        json_response 200, fixture('retrieve_setup_intent')
      else
        json_response 200, fixture("create_setup_intent")
      end
    end

    get '/v1/setup_intents/:id' do
      # succeeded with attached payment_method and customer
      json_response 200, fixture("retrieve_setup_intent")
    end

    post '/v1/setup_intents/:id' do
      # succeeded with attached payment_method and customer + user_id
      json_response 200, fixture('update_setup_intent')
    end

    post '/v1/setup_intents/:id/confirm' do
      # succeeded with attached payment_method and customer
      json_response 200, fixture('retrieve_setup_intent')
    end

    post '/v1/setup_intents/:id/cancel' do
      json_response 200, fixture('cancel_setup_intent')
    end

    get '/v1/setup_intents' do
      json_response 200, fixture('list_setup_intents')
    end

    # Payout
    post '/v1/payouts' do
      json_response 200, fixture("create_payout")
    end

    get '/v1/payouts/:id' do
      json_response 200, fixture("retrieve_payout")
    end

    post '/v1/payouts/:id' do
      json_response 200, fixture('update_payout')
    end

    post '/v1/payouts/:id/cancel' do
      json_response 200, fixture('cancel_payout')
    end

    get '/v1/payouts' do
      json_response 200, fixture('list_payouts')
    end

    # Session (checkout)
    post '/v1/checkout/sessions' do
      json_response 200, fixture("create_session")
    end

    get '/v1/sessions/:id' do
      json_response 200, fixture("retrieve_session")
    end

    get '/v1/checkout/sessions' do
      json_response 200, fixture('list_sessions')
    end

    get '/v1/checkout/sessions/:id/line_items' do
      json_response 200, fixture('retrieve_session_line_items')
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
  end
end
