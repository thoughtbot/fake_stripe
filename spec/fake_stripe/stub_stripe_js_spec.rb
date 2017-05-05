require 'spec_helper'

describe FakeStripe::StubStripeJS do
  describe '#boot_once' do
    it 'returns the same server each invocation' do
      expect(described_class.boot_once).to eq described_class.boot_once
    end
  end

  describe '#server_port' do
    it 'returns the same value each invocation' do
      expect(described_class.server_port).to eq described_class.server_port
    end
  end
end
