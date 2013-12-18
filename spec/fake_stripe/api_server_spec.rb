require 'spec_helper'

describe FakeStripe::ApiServer, 'POST /v1/charges' do
  it 'fakes a charge response' do
    expect(Stripe::Charge.create().paid).to eq true
  end

  it 'records that a request was made' do
    expect do
      Stripe::Charge.create()
    end.to change(FakeStripe, :charge_count).by(1)
  end
end
