require 'capybara'
require 'capybara/server'
require 'sinatra/base'

module FakeStripe
  class StubStripeJS < Sinatra::Base
    get '/v1/' do
      file_path = File.join(File.dirname(__FILE__), '/assets/v1.js')

      content_type 'text/javascript'
      status 200
      File.open(file_path, 'rb').read
    end

    def self.boot
      instance = new
      Capybara::Server.new(instance).tap { |server| server.boot }
    end
  end
end
