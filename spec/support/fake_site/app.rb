require 'sinatra/base'
require 'sinatra/cors'

module FakeSite
  class App < Sinatra::Base
    register Sinatra::Cors

    def self.url=(url)
      @@url = url
    end

    def self.url
      @@url
    end

    get "/pay" do
      url = URI.parse(STRIPE_JS_HOST)
      url.path = "/v3/"

      payment_intent = Stripe::PaymentIntent.create(
        amount: 1000,
        currency: 'usd'
      )

      erb :pay, locals: {
        stripe_publishable_key: 'pk_test_1234',
        stripe_js_url: url,
        client_secret: payment_intent.client_secret
      }
    end

    post "/confirmation" do
      erb :confirmation
    end
  end
end

