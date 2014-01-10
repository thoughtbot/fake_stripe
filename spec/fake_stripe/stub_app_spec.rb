require 'spec_helper'

describe FakeStripe::StubApp, 'POST /v1/charges' do
  let(:customer) { Stripe::Customer.retrieve('anything') }

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

  context 'cards' do
    it 'adds cards to the customer and gives them a unique id' do
      customer.cards.create(card: 'a token')
      customer.cards.create(card: 'a second token')

      expect(cards.count).to eq(2)
      expect(cards.first.id).not_to eq(cards.second.id)
    end

    it 'resets cards between runs' do
      pending
      customer.cards.create(card: 'a token')
      FakeStripe.reset!

      expect(cards.count).to eq(0)
    end

    it 'assigns ids to cards beginning with "card_"' do
      pending
      customer.cards.create(card: 'a token')

      expect(cards.first.id).to start_with("card_")
    end
  end
end
