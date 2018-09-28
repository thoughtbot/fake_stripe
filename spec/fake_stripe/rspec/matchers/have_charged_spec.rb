require 'spec_helper'

describe 'have_charged' do
  it 'matches charges that have the correct amount' do
    charges = [charge(100)]
    fake_stripe = double(charge_calls: charges)

    expect(fake_stripe).to have_charged(100)
    expect(fake_stripe).not_to have_charged(200)
  end

  it 'matches multiple charges' do
    charges = [charge(100), charge(200)]
    fake_stripe = double(charge_calls: charges)

    expect(fake_stripe).to have_charged(100)
    expect(fake_stripe).to have_charged(200)
  end

  it 'ignores the card token if no card token was given' do
    charges = [charge(100, 'card_1234')]
    fake_stripe = double(charge_calls: charges)

    expect(fake_stripe).to have_charged(100)
  end

  it 'matches charges with the correct amount and card' do
    expect(fake_stripe(charge(100, 'card_1'))).to have_charged(100).to_card('card_1')
  end

  it 'does not match the correct amount with the wrong card token' do
    expect(fake_stripe(charge(200, 'card_1'))).not_to have_charged(200).to_card('card_2')
  end

  it 'does not match the wrong amount with the correct card token' do
    expect(fake_stripe(charge(100, 'card_2'))).not_to have_charged(200).to_card('card_2')
  end

  it 'does not match when all conditions are met but by different charges' do
    stripe = fake_stripe(charge(100, 'card_1'), charge(200, 'card_2'))

    expect(stripe).not_to have_charged(100).to_card('card_2')
  end

  it 'raises an exception when checking charges to nil' do
    expect_invalid_card_token(nil)
  end

  it 'raises an exception when checking charges to empty string' do
    expect_invalid_card_token('')
  end

  def expect_invalid_card_token(card_token)
    expect do
      expect(fake_stripe).to have_charged(100).to_card(card_token)
    end.to raise_exception(FakeStripe::InvalidCardToken)
  end

  def fake_stripe(*charges)
    double(charge_calls: charges)
  end

  def charge(amount, card_token = nil)
    charge = { amount: amount }
    if card_token
      charge[:card] = { id: card_token }
    end
    charge
  end
end
