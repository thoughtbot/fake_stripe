require "spec_helper"

describe FakeStripe::StubStripeConnect do
  it_behaves_like "a bootable server"
  include Rack::Test::Methods

  def app
    FakeStripe::StubStripeConnect.new
  end

  describe "GET /oauth/authorize" do
    it "redirects to redirect_uri" do
      redirect_uri = "http://example.com/"
      expected_url = URI(redirect_uri)
      expected_url.query = URI.encode_www_form(
        state: "Test",
        code: described_class::CODE,
      )

      get "/oauth/authorize", redirect_uri: redirect_uri, state: "Test"

      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.url).to eq(expected_url.to_s)
    end
  end
end
