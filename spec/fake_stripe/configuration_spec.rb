require 'spec_helper'

describe FakeStripe::Configuration, '#fixture_path' do
  let!(:new_fixture_path) { '/custom/fixture/path' }
  let!(:previous_fixture_paths) { FakeStripe.fixture_paths }

  before do
    FakeStripe.configure do |config|
      config.fixture_path = new_fixture_path
    end
  end

  after do
    FakeStripe.configure do |config|
      config.fixture_paths = [previous_fixture_paths]
    end
  end

  it 'returns the config fixture path' do
    expect(FakeStripe.fixture_paths).to eq [new_fixture_path]
  end
end
