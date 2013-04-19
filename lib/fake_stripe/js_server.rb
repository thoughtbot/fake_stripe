require 'capybara'
require 'capybara/server'
require 'sinatra/base'

module FakeStripe
  class JsServer < Sinatra::Base
    get '/v1/' do
      content_type 'text/javascript'
      status 200
      File.open(File.dirname(__FILE__) + '/assets/v1.js', 'rb').read
    end

    def self.boot
      instance = new
      Capybara::Server.new(instance).tap { |server| server.boot }
    end
  end
end
