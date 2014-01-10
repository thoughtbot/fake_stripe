require 'sinatra/base'

module FakeStripe
  class StubApp < Sinatra::Base
    post '/v1/customers' do
      json_response 200, fixture('list_customers')
    end

    get '/v1/customers/:id' do
      json_response 200, customer_response.to_json
    end

    post '/v1/customers/:customer_id/subscription' do
      json_response 200, fixture('update_subscription')
    end

    delete '/v1/customers/:customer_id/subscription' do
      json_response 200, fixture('cancel_subscription')
    end

    get '/v1/events/:id' do
      json_response 200, fixture('retrieve_event')
    end

    post '/v1/charges' do
      charge = successful_charge
      FakeStripe.charges << charge
      json_response 201, charge.to_json
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

    def successful_charge
      {
        amount: params[:amount].to_i,
        customer: CUSTOMER_ID,
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
        created: 1360691193,
        currency: "usd",
        description: "Polygonian licensing",
        dispute: nil,
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
        id: "ch_1HLqBx9AyixBof",
        invoice: nil,
        livemode: false,
        object: "charge",
        paid: true,
        refunded: false
      }
    end

    def customer_response
      {
        active_card: FakeStripe.cards.first,
        cards: cards_response,
        account_balance: 0,
        created: 1358789849,
        delinquent: false,
        description: nil,
        discount: nil,
        email: nil,
        id: CUSTOMER_ID,
        livemode: false,
        object: "customer",
        subscription: nil
      }
    end

    def cards_response
      {
        object: "list",
        count: FakeStripe.cards.size,
        url: "/v1/customers/#{CUSTOMER_ID}/cards",
        data: FakeStripe.cards
      }
    end
  end
end
