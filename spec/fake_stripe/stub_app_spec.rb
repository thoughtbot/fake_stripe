require 'spec_helper'

describe FakeStripe::StubApp do
  describe 'POST /v1/charges' do
    it 'returns a fake charge response' do
      result = Stripe::Charge.create

      expect(result.paid).to eq true
    end

    it 'increments the charge counter' do
      expect do
        Stripe::Charge.create
      end.to change(FakeStripe, :charge_count).by(1)
    end
  end

  describe 'POST /v1/charges/:charge_id/refund' do
    it 'returns a fake refund response' do
      result = Stripe::Charge.retrieve('ABC123').refund

      expect(result.refunded).to eq true
    end

    it 'increments the refund counter' do
      expect do
        Stripe::Charge.retrieve('ABC123').refund
      end.to change(FakeStripe, :refund_count).by(1)
    end
  end

  describe "POST /v1/customers" do
    it "increments the customer counter" do
      expect do
        Stripe::Customer.create
      end.to change(FakeStripe, :customer_count).by(1)
    end
  end

  describe "POST /v1/customers/:customer_id/cards" do
    it "increments the card counter" do
      customer = Stripe::Customer.retrieve("ABC123")

      expect do
        customer.cards.create(card: "xyz890")
      end.to change(FakeStripe, :card_count).by(1)
    end
  end

  describe "POST /v1/customers/:customer_id/subscriptions" do
    it "increments the subscription counter" do
      customer = Stripe::Customer.retrieve("ABC123")

      expect do
        customer.subscriptions.create(plan: "xyz890")
      end.to change(FakeStripe, :subscription_count).by(1)
    end
  end

  describe "POST /v1/plans" do
    it "increments the plan counter" do
      expect do
        Stripe::Plan.create
      end.to change(FakeStripe, :plan_count).by(1)
    end
  end

  describe "POST /v1/coupons" do
    it "increments the coupon counter" do
      expect do
        Stripe::Coupon.create
      end.to change(FakeStripe, :coupon_count).by(1)
    end
  end

  describe "POST /v1/invoices" do
    it "increments the invoice counter" do
      expect do
        Stripe::Invoice.create
      end.to change(FakeStripe, :invoice_count).by(1)
    end
  end

  describe "POST /v1/invoiceitems" do
    it "increments the invoiceitem counter" do
      expect do
        Stripe::InvoiceItem.create
      end.to change(FakeStripe, :invoiceitem_count).by(1)
    end
  end

  describe "POST /v1/transfers" do
    it "increments the transfer counter" do
      expect do
        Stripe::Transfer.create
      end.to change(FakeStripe, :transfer_count).by(1)
    end
  end

  describe "POST /v1/recipients" do
    it "increments the recipient counter" do
      expect do
        Stripe::Recipient.create
      end.to change(FakeStripe, :recipient_count).by(1)
    end
  end

  describe "POST /v1/tokens" do
    it "increments the token counter" do
      expect do
        Stripe::Token.create
      end.to change(FakeStripe, :token_count).by(1)
    end
  end
end
