require 'sinatra/base'

module FakeStripe
  class StubApp < Sinatra::Base
    post '/v1/customers' do
      json_response 200, fixture('list_customers')
    end

    get '/v1/customers/:id' do
      json_response 200, fixture('retrieve_customer')
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
      FakeStripe.charge_count += 1
      json_response 201, fixture('create_charge')
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
  end
end
