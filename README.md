# fake\_stripe, a Stripe fake

This library is a way to test [Stripe](http://www.stripe.com/) code without hitting Stripes's
servers. It uses
[Capybara::Server](https://github.com/jnicklas/capybara/blob/master/lib/capybara/server.rb)
and [Webmock](https://github.com/bblimke/webmock) to intercept all of the calls from Stripes's
Ruby library and returns JSON that the Stripe library can parse.

## Installation

### Gemfile

Add the `fake_stripe` Gem to the `:test` group in your Gemfile:

    # Gemfile
    group :test do
      gem 'fake_stripe', git: 'git@github.com:thoughtbot/fake_stripe.git'
    end

Remember to run `bundle install`.

### Stripe settings

Set the `STRIPE_JS_HOST` constant in an initializer:

    # config/initilialzers/stripe.rb
    Stripe.api_key = ENV['STRIPE_API_KEY']

    unless defined? STRIPE_JS_HOST
      STRIPE_JS_HOST = 'https://js.stripe.com'
    end

Include the Stripe javascript in your application template:

    # app/views/layouts/application.html.erb
    <%= javascript_include_tag "#{STRIPE_JS_HOST}/v1/" %>

When the test suite runs `fake_stripe` will override the address for
`STRIPE_JS_HOST` and serve up a local version of [Stripe.js](https://stripe.com/docs/stripe.js).

### Test suite

Require the library in your spec helper:

    require 'fake_stripe'

Use webmock to mount the fake server, and `FakeStripe.reset!` will clear all flags, and data, which
you almost certainly want to do before each test.

    # spec/support/fake_stripe.rb
    RSpec.configure do |config|
      config.before(:each) do
        FakeStripe.reset!
        stub_request(:any, /api.stripe.com/).to_rack(FakeStripe::ApiServer)
      end
    end

### Flags

To simulate failures in the Stripe API there is a helper method that called before any test
to create a failure.

    FakeStripe.fail_all_requests

## Contributing

Please see [CONTRIBUTING.md][1] for more details.

[1]: https://github.com/thoughtbot/fake_stripe/blob/master/CONTRIBUTING.md
