require 'spec_helper'

describe 'Subscription request' do
  include Rack::Test::Methods

  SUBSCRIPTIONS_TESTS = {
    # Subscriptions
    'POST customers/:customer_id/subscriptions' =>
       { route: '/v1/customers/1/subscriptions', method: :post },
    'GET customers/:customer_id/subscriptions/:subscription_id' =>
       { route: '/v1/customers/1/subscriptions/1', method: :get },
    'POST customers/:customer_id/subscriptions/:subscription_id' =>
       { route: '/v1/customers/1/subscriptions/1', method: :post },
    'DELETE customers/:customer_id/subscriptions/:subscription_id' =>
       { route: '/v1/customers/1/subscriptions/1', method: :delete }
  }

  SUBSCRIPTIONS_TESTS.each_pair do |name, action|
    describe name do
      it 'includes plan hash in response' do
        send action[:method], action[:route]

        expect(JSON.parse(last_response.body)["plan"]["interval"]).to eq "month"
      end
    end
  end

  describe 'GET customers/:customer_id/subscriptions' do
    it 'includes plan hash in response' do
      get '/v1/customers/1/subscriptions'

      expect(JSON.parse(last_response.body)["data"][0]["plan"]["interval"]).to eq "month"
    end
  end

  def app
    FakeStripe::StubApp.new
  end
end
