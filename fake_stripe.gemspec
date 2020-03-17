$:.push File.expand_path('../lib', __FILE__)

require 'fake_stripe/version'

Gem::Specification.new do |s|
  s.name        = 'fake_stripe'
  s.version     = FakeStripe::VERSION
  s.authors     = ['Harlow Ward']
  s.email       = ['harlow@thoughtbot.com', 'caleb@thoughtbot.com', 'mason@thoughtbot.com', 'damian@thoughtbot.com']
  s.homepage    = 'https://github.com/thoughtbot/fake_stripe'
  s.summary     = 'A fake Stripe server.'
  s.description = 'An implementation of the Stripe credit card processing service to run during your integration tests.'

  s.files = Dir["{lib}/**/*"] + ['CONTRIBUTING.md', 'LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'capybara'
  s.add_dependency 'sinatra'
  s.add_dependency 'webmock'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'puma'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'stripe'
end
