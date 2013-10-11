require 'spec_helper'

describe FakeStripe::StubApp, 'POST /v1/charges' do
  it 'returns a fake charge respone' do
    result = Stripe::Charge.create

    expect(result.paid).to eq true
  end

  it 'increments the charge counter' do
    expect do
      Stripe::Charge.create
    end.to change(FakeStripe, :charge_count).by(1)
  end
end
