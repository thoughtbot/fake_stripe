require 'webmock'
include WebMock::API
WebMock.enable!
WebMock.disable_net_connect!(allow_localhost: true)
