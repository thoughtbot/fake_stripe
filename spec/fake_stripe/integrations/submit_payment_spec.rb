require 'spec_helper'
require 'capybara/rspec'
require 'capybara/cuprite'

RSpec.describe 'Stripe payment form', type: :feature, js: true do
  before do
    FakeSiteRunner.boot
    Capybara.app = FakeSite::App
    Capybara.current_driver = :apparition
    Capybara.default_max_wait_time = 30
    FakeStripe.configure do |config|
      config.api_host = STRIPE_API_HOST
    end
  end

  context "when using credit card" do
    it 'allows the user to complete a payment' do
      visit '/pay'
      fill_in 'cardnumber', with: '4242424242424242'
      fill_in 'exp-date', with: '12/25'
      fill_in 'cvc', with: '123'
      click_button 'Pay'

      expect(page).to have_content 'Payment succeeded'
      expect(page).to have_content 'pi_'
      expect(FakeStripe.payment_intent_count).to eq(1)
      expect(FakeStripe.charge_count).to eq(1)
    end

    context 'when a payment fails' do
      it 'returns an error' do
        visit '/declined'
        fill_in 'cardnumber', with: '4000000000000002'
        fill_in 'exp-date', with: '12/25'
        fill_in 'cvc', with: '123'
        click_button 'Pay'

        expect(page).to have_content 'Your card was declined'
        expect(FakeStripe.payment_intent_count).to eq(1)
        expect(FakeStripe.charge_count).to eq(0)
      end
    end

    context 'when a request fails' do
      it 'rejects the promise' do
        visit '/rejected'
        fill_in 'cardnumber', with: '4000000000000002'
        fill_in 'exp-date', with: '12/25'
        fill_in 'cvc', with: '123'
        click_button 'Pay'

        expect(page).to have_content 'Payment Intent not found'
        expect(FakeStripe.payment_intent_count).to eq(0)
        expect(FakeStripe.charge_count).to eq(0)
      end
    end
  end

  context 'when using ACH' do
    it 'allows the user to complete a payment' do
      visit '/ach'
      click_button 'Pay $10'
      expect(page).to have_content 'STRIPE TEST BANK'
      click_button 'Pay $10'

      expect(page).to have_content 'Payment processing'
      expect(page).to have_content 'pi_'
      expect(FakeStripe.payment_intent_count).to eq(1)
      expect(FakeStripe.charge_count).to eq(1)
    end
  end
end
