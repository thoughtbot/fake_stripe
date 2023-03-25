require 'sinatra/base'

module FakeSite
  class App < Sinatra::Base

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

      erb :pay, locals: { stripe_js_url: url, client_secret: payment_intent.client_secret }
    end

    post "/confirmation" do
      erb :confirmation
    end
  end
end

