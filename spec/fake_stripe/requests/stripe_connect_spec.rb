require "spec_helper"

describe "Stripe Connect" do
  include Rack::Test::Methods

  describe "POST /oauth/token" do
    context "when the code matches" do
      it "returns a success response" do
        post "/oauth/token?code=#{code}"

        expect(last_response.status).to eq(200)
      end

      it "returns the expected attributes" do
        post "/oauth/token?code=#{code}"

        response = JSON.parse(last_response.body)
        expect(response.keys).to contain_exactly(
          "access_token",
          "livemode",
          "refresh_token",
          "token_type",
          "stripe_publishable_key",
          "stripe_user_id",
          "scope",
        )
      end
    end

    context "when the code does NOT match" do
      it "returns a 400 response" do
        post("/oauth/token?code=invalid_code")

        expect(last_response.status).to eq(400)
      end

      it "returns an error message" do
        code = "invalid_code"
        post("/oauth/token?code=#{code}")

        response = JSON.parse(last_response.body)
        expect(response).to eq(
          "error" => "invalid_grant",
          "error_description" => "Authorization code does not exist: #{code}",
        )
      end
    end
  end

  describe "GET /express/oauth/authorize" do
    it "redirects to the redirect_uri with the given state and a code" do
      redirect = "http://example.com/redirect"
      state = "state"
      get "/express/oauth/authorize?redirect_uri=#{redirect}&state=#{state}"

      expect(last_response.location).
        to eq("#{redirect}\?state=#{state}&code=#{code}")
    end
  end

  def code
    FakeStripe::StubStripeConnect::CODE
  end

  def app
    FakeStripe::StubStripeConnect.new
  end
end
