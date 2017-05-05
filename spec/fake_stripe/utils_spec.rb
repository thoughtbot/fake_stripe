require 'spec_helper'

describe FakeStripe::Utils do
  describe '#find_available_port' do
    it 'returns a port value' do
      expect(described_class.find_available_port).to be_a Numeric
    end
  end
end
