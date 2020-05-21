require "fake_stripe/bootable"
require "sinatra/base"

module FakeStripe
  class StubStripeConnect < Sinatra::Base
    extend Bootable

    CODE = "stripe_connect_express_oauth_authorization_code".freeze

    post "/oauth/token" do
      code = params[:code]
      if code == CODE
        {
          access_token: "ACCESS_TOKEN",
          livemode: false,
          refresh_token: "REFRESH_TOEKN",
          token_type: "bearer",
          stripe_publishable_key: "PUBLISHABLE_KEY",
          stripe_user_id: "acc_stripe_user_id",
          scope: "express",
        }.to_json
      else
        status 400
        {
          error: "invalid_grant",
          error_description: "Authorization code does not exist: #{code}",
        }.to_json
      end
    end

    get "/express/oauth/authorize" do
      uri = URI(params[:redirect_uri])
      uri.query = URI.encode_www_form(state: params[:state], code: CODE)
      redirect uri
    end
  end
end