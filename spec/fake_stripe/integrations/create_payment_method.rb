require 'spec_helper'
require 'capybara/rspec'
require 'capybara/cuprite'

RSpec.describe 'Create payment method', type: :feature, js: true do
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
      fill_in 'cardnumber', with: '4242 4242 4242 4242'
      fill_in 'exp-date', with: '12/25'
      fill_in 'cvc', with: '123'

      expect(page).to have_content 'credit'
    end
  end

  context "when using debit card" do
    it 'allows the user to complete a payment' do
      visit '/pay'
      fill_in 'cardnumber', with: '5200828282828210'
      fill_in 'exp-date', with: '12/25'
      fill_in 'cvc', with: '123'

      expect(page).to have_content 'debit'
    end
  end

  context "when using prepaid card" do
    it 'allows the user to complete a payment' do
      visit '/pay'
      fill_in 'cardnumber', with: '5105105105105100'
      fill_in 'exp-date', with: '12/25'
      fill_in 'cvc', with: '123'

      expect(page).to have_content 'prepaid'
    end
  end
end
