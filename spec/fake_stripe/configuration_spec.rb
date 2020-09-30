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
    let!(:new_stripe_token) { 'abc123' }
    let!(:previous_stripe_token) { FakeStripe.stripe_token }

    after do
      FakeStripe.configure do |config|
        config.stripe_token = previous_stripe_token
      end
    end

    it 'returns the config stripe token' do
      FakeStripe.configure do |config|
        config.stripe_token = new_stripe_token
      end

      expect(FakeStripe.stripe_token).to eq new_stripe_token
    end

    it 'returns a default token' do
      expect(FakeStripe.stripe_token).to eq 'tok_123'
    end
  end
end
