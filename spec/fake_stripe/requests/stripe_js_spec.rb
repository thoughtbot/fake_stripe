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

      expect(response).to include "class FakeStripeElement"
    end
  end
end
