require 'spec_helper'

describe FakeStripe::StubApp do
  describe 'POST /v1/charges' do
    it 'returns a fake charge response' do
      result = Stripe::Charge.create

      expect(result.paid).to eq true
    end

    it 'increments the charge counter' do
      expect do
        Stripe::Charge.create
      end.to change(FakeStripe, :charge_count).by(1)
    end
  end

  describe 'POST /v1/charges/:charge_id/refund' do
    it 'returns a fake refund response' do
      result = Stripe::Charge.retrieve('ABC123').refund

      expect(result.refunded).to eq true
    end

    it 'increments the refund counter' do
      expect do
        Stripe::Charge.retrieve('ABC123').refund
      end.to change(FakeStripe, :refund_count).by(1)
    end
  end
end
