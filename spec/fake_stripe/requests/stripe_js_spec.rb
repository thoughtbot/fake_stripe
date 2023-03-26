require "spec_helper"
require "net/http"

describe "Stub Stripe JS" do
  context "v1" do
    it "returns the requested asset" do
      url = URI.parse(STRIPE_JS_HOST)
      url.path = "/v1/"

      response = Net::HTTP.get(url)

      expect(response).to include "window.Stripe"
    end
  end

  context "v2" do
    it "returns the requested asset" do
      url = URI.parse(STRIPE_JS_HOST)
      url.path = "/v2/"

      response = Net::HTTP.get(url)

      expect(response).to include "var Stripe"
    end
  end

  context "v3" do
    it "returns the requested asset" do
      url = URI.parse(STRIPE_JS_HOST)
      url.path = "/v3/"

      response = Net::HTTP.get(url)

      expect(response).to include "class StripeElement"
    end

    context "when a js_v3_token is set" do
      let!(:previous_js_v3_token) { FakeStripe.js_v3_token }
      after do
        FakeStripe.configure do |config|
          config.js_v3_token = previous_js_v3_token
        end
      end

      it "sets the token in requests" do
        custom_token = "abc123"
        FakeStripe.configure do |config|
          config.js_v3_token = custom_token
        end
        url = URI.parse(STRIPE_JS_HOST)
        url.path = "/v3/"

        response = Net::HTTP.get(url)

        expect(response).to include custom_token
      end

      it "sets the api_key in requests" do
        api_key = "sk_test_12345"
        FakeStripe.configure do |config|
          config.api_key = api_key
        end
        url = URI.parse(STRIPE_JS_HOST)
        url.path = "/v3/"

        response = Net::HTTP.get(url)

        expect(response).to include api_key
      end

      it "sets the api_host in requests" do
        api_host = "localhost:14034"
        FakeStripe.configure do |config|
          config.api_host = api_host
        end
        url = URI.parse(STRIPE_JS_HOST)
        url.path = "/v3/"

        response = Net::HTTP.get(url)

        expect(response).to include api_host
      end
    end

    it "returns field validation errors" do
      url = URI.parse(STRIPE_JS_HOST)
      url.path = "/v3/"
      errors = "resolve({ error: { message: errorMessage() } })"

      response = Net::HTTP.get(url)

      expect(response).to include errors
    end
  end
end
