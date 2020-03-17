require "fake_stripe/bootable"
require "sinatra/base"

module FakeStripe
  class StubStripeJS < Sinatra::Base
    extend Bootable

    get "/v1/" do
      file_path = File.join(File.dirname(__FILE__), "/assets/v1.js")

      content_type "text/javascript"
      status 200
      IO.read(file_path)
    end

    get "/v2/" do
      file_path = File.join(File.dirname(__FILE__), "/assets/v2.js")
      mock_file_path = File.join(File.dirname(__FILE__), "/assets/v2-mock.js")

      content_type "text/javascript"
      status 200
      IO.read(file_path) + IO.read(mock_file_path)
    end

    get "/v3/" do
      file_path = File.join(File.dirname(__FILE__), "/assets/v3.js")

      content_type "text/javascript"
      status 200
      IO.read(file_path)
    end
  end
end
