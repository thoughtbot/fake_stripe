require 'webmock'
require 'capybara'

include WebMock::API
WebMock.enable!
WebMock.disable_net_connect!(allow_localhost: true)
Capybara.server = :webrick
