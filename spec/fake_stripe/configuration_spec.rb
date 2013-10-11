require 'spec_helper'

describe FakeStripe::Configuration, '#fixture_path' do
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
