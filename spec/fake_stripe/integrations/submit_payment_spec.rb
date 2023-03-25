require 'spec_helper'
require 'capybara/rspec'
require 'capybara/cuprite'

RSpec.describe 'Stripe payment form', type: :feature, js: true do
  before do
    FakeSiteRunner.boot
    Capybara.app = FakeSite::App
    Capybara.current_driver = :apparition
    Capybara.default_max_wait_time = 30
  end

  it 'allows the user to complete a payment' do
    visit '/pay'
    fill_in 'cardnumber', with: '4242424242424242'
    fill_in 'exp-date', with: '12/25'
    fill_in 'cvc', with: '123'
    click_button 'Pay'

    expect(page).to have_content 'Payment succeeded'
  end
end
