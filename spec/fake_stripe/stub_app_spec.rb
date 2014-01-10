require 'spec_helper'

describe FakeStripe::StubApp do
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

    it 'charges customers with existing cards' do
      card = customer.cards.create(card: 'a token')
      Stripe::Charge.create(amount: 100, currency: 'usd', customer: customer.id, card: card.id)

      expect(FakeStripe).to have_charged(100).to_card(card.id)
    end

    it "raises an exception when charging a card that doesn't belong to a customer" do
      expect do
        Stripe::Charge.create(amount: 500, currency: 'usd', card: 'a card', customer: customer.id)
      end.to raise_exception(Stripe::InvalidRequestError)

      expect(FakeStripe).not_to have_charged(500)
    end
  end

  context 'cards' do
    it 'adds cards to the customer and gives them a unique id' do
      customer.cards.create(card: 'a token')
      customer.cards.create(card: 'a second token')

      expect(cards.count).to eq(2)
      expect(cards.first.id).not_to eq(cards.last.id)
    end

    it 'resets cards between runs' do
      customer.cards.create(card: 'a token')
      FakeStripe.reset

      expect(cards.count).to eq(0)
    end

    it 'assigns ids to cards beginning with "card_"' do
      customer.cards.create(card: 'a token')

      expect(cards.first.id).to start_with("card_")
    end

    def cards
      customer.cards.all.data
    end
  end
end
