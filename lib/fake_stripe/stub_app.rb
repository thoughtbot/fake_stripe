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
      charge = Charge.new(FakeStripe.card_ids, params)

      if charge.valid?
        FakeStripe.charges << charge.response
        json_response(201, charge.response.to_json)
      else
        json_response(404, charge.error.to_json)
      end
    end

    get '/v1/customers/:customer_id/cards' do
      json_response 200, cards_response.to_json
    end

    post '/v1/customers/:customer_id/cards' do
      id = next_card_id
      card = new_card(id)
      FakeStripe.customer_cards[id] = card
      json_response 201, card.to_json
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

    def next_card_id
      "card_#{FakeStripe.cards.size}"
    end

    def new_card(id)
      {
        id: id,
        customer: CUSTOMER_ID,
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
        exp_year: 2015,
        fingerprint: "sHKpS2lYHtT5ZU5L",
        last4: "4242",
        name: nil,
        object: "card",
        type: "Visa"
      }
    end
  end
end
