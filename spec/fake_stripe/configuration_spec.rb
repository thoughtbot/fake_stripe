require 'spec_helper'

describe FakeStripe::Configuration, '#fixture_path' do
  context 'when setting the fixture_path' do
    let!(:new_fixture_path) { '/custom/fixture/path' }
    let!(:previous_fixture_path) { FakeStripe.fixture_path }

    before do
      FakeStripe.configure do |config|
        config.fixture_path = new_fixture_path
      end
    end

    after do
      FakeStripe.configure do |config|
        config.fixture_path = previous_fixture_path
      end
    end

    it 'returns the config fixture path' do
      expect(FakeStripe.fixture_path).to eq new_fixture_path
    end
  end

  context 'when setting the stripe token' do
    let!(:new_js_v3_token) { 'abc123' }
    let!(:previous_js_v3_token) { FakeStripe.js_v3_token }

    after do
      FakeStripe.configure do |config|
        config.js_v3_token = previous_js_v3_token
      end
    end

    it 'returns the config stripe token' do
      FakeStripe.configure do |config|
        config.js_v3_token = new_js_v3_token
      end

      expect(FakeStripe.js_v3_token).to eq new_js_v3_token
    end

    it 'returns a default token' do
      expect(FakeStripe.js_v3_token).to eq 'tok_123'
    end
  end

  context 'when setting the api_key' do
    let!(:new_api_key) { 'sk_1234' }
    let!(:previous_api_key) { FakeStripe.api_key }

    before do
      FakeStripe.configure do |config|
        config.api_key = new_api_key
      end
    end

    after do
      FakeStripe.configure do |config|
        config.api_key = previous_api_key
      end
    end

    it 'returns the api key' do
      expect(FakeStripe.api_key).to eq new_api_key
    end
  end

  context 'when setting the stripe_account' do
    let!(:new_stripe_account) { 'acct_1234' }
    let!(:previous_stripe_account) { FakeStripe.stripe_account }

    before do
      FakeStripe.configure do |config|
        config.stripe_account = new_stripe_account
      end
    end

    after do
      FakeStripe.configure do |config|
        config.stripe_account = previous_stripe_account
      end
    end

    it 'returns the api key' do
      expect(FakeStripe.stripe_account).to eq new_stripe_account
    end
  end

  context 'when setting the api_host' do
    let!(:new_api_host) { 'http://localhost:32984' }
    let!(:previous_api_host) { 'api.stripe.com' }

    before do
      FakeStripe.configure do |config|
        config.api_host= new_api_host
      end
    end

    after do
      FakeStripe.configure do |config|
        config.api_host= previous_api_host
      end
    end

    it 'returns the api_host' do
      expect(FakeStripe.api_host).to eq new_api_host
    end
  end
end
