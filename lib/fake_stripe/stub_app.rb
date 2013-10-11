require 'sinatra/base'

module FakeStripe
  class StubApp < Sinatra::Base
    post '/v1/customers' do
      json_response 200, 'list_customers'
    end

    get '/v1/customers/:id' do
      json_response 200, 'retrieve_customer'
    end

    post '/v1/customers/:customer_id/subscription' do
      json_response 200, 'update_subscription'
    end

    delete '/v1/customers/:customer_id/subscription' do
      json_response 200, 'cancel_subscription'
    end

    get '/v1/events/:id' do
      json_response 200, 'retrieve_event'
    end

    post '/v1/charges' do
      FakeStripe.charge_count += 1
      json_response 201, 'create_charge'
    end

    private

    def json_response(response_code, file_name)
      file_path = File.join(FakeStripe.fixture_path, "#{file_name}.json")

      content_type :json
      status response_code
      File.open(file_path, 'rb').read
    end
  end
end
