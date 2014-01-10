require 'spec_helper'

module FakeStripe
  describe Charge do
    describe '#valid?' do
      it 'is valid if no customer id is given' do
        charge = Charge.new([], amount: 100)
        expect(charge).to be_valid
      end

      it 'is valid if the card_token is included in the given cards' do
        charge = Charge.new(['card_1'], customer: 'something', card: 'card_1')

        expect(charge).to be_valid
      end

      it 'is invalid if the card_token is not included in the given cards' do
        charge = Charge.new(['card_1'], customer: 'something', card: 'card_2')

        expect(charge).not_to be_valid
      end
    end

    describe '#response' do
      it 'typecasts the amount to an integer' do
        charge = Charge.new([], amount: '100')

        expect(charge.response[:amount]).to eq(100)
      end
    end
  end
end
