require 'spec_helper'

describe FakeStripe::StubApp, 'POST /v1/charges' do
  context 'charges' do
    it 'returns a fake charge respone' do
      result = Stripe::Charge.create

      expect(result.paid).to eq true
    end

    it 'charges customers' do
      Stripe::Charge.create(amount: 400, currency: 'usd', card: 'a card')

      expect(FakeStripe).to have_charged(400).to_card('a card')
    end

    it 'resets charges between runs' do
      Stripe::Charge.create(amount: 500, currency: 'usd', card: 'a card')
      FakeStripe.reset

      expect(FakeStripe).not_to have_charged(500)
    end
  end
end
