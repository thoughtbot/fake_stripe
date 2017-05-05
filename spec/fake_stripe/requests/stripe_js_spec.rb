require 'spec_helper'
require 'net/http'

describe 'Stub Stripe JS' do
  it 'returns the requested asset' do
    url = URI.parse(STRIPE_JS_HOST)
    url.path = '/v1/'

    response = Net::HTTP.get(url)

    expect(response).to include 'window.Stripe'
  end
end
