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

    get "/declined" do
      url = URI.parse(STRIPE_JS_HOST)
      url.path = "/v3/"

      payment_intent = Stripe::PaymentIntent.create(
        amount: 1000,
        currency: 'usd'
      )
      erb :pay, locals: {
        stripe_publishable_key: 'pk_test_1234',
        stripe_js_url: url,
        client_secret: "#{payment_intent.client_secret}_declined"
      }
    end

    post "/confirmation" do
      payment_intent_id = params[:payment_intent_id]
      erb :confirmation, locals: {
        payment_intent_id: payment_intent_id,
        message: params[:message]
      }
    end
  end
end

