require 'spec_helper'
require 'capybara/rspec'
require 'capybara/cuprite'

RSpec.describe 'getElement()', type: :feature, js: true do
  before do
    FakeSiteRunner.boot
    Capybara.app = FakeSite::App
    Capybara.current_driver = :apparition
    Capybara.default_max_wait_time = 30
    FakeStripe.configure do |config|
      config.api_host = STRIPE_API_HOST
    end
  end

  context "when element is CardNumberElement" do
    it 'accesses the card number' do
      visit '/pay'
      fill_in 'cardnumber', with: '4242424242424242'
      fill_in 'exp-date', with: '12/25'
      fill_in 'cvc', with: '123'

      binding.pry
      expect(page).to have_content 'cardNumber: 4242424242424242'
    end
  end
end
