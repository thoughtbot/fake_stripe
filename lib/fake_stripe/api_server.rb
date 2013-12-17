require 'sinatra/base'

module FakeStripe
  class ApiServer < Sinatra::Base
    post '/v1/customers' do
      if FakeStripe.error_response?
        json_response 402, 'customers_card_error'
      else
        json_response 200, 'customers'
      end
    end

    get '/v1/customers/:id' do
      json_response 200, 'customer'
    end

    post '/v1/customers/:customer_id/subscription' do
      json_response 200, 'update_subscription'
    end

    delete '/v1/customers/:customer_id/subscription' do
      json_response 200, 'cancel_subscription'
    end

    get '/v1/events/:id' do
      json_response 200, 'charge_succeeded'
    end

    post '/v1/charges' do
      FakeStripe.charge_count += 1
      json_response 201, 'charge_response'
    end

    private

    def json_response(response_code, file_name)
      content_type :json
      status response_code
      File.open(File.dirname(__FILE__) + '/fixtures/' + file_name + '.json', 'rb').read
    end
  end
end


