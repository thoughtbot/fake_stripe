require 'spec_helper'

# describe FakeStripe::StubApp do
#   describe "GET /v1/accounts/:account_id" do
#     it "returns an account response" do
#       result = Stripe::Account.retrieve("stripe-account-id")
# 
#       expect(result.object).to eq("account")
#     end
#   end
# 
#   describe "GET /v1/account" do
#     it "returns an account response" do
#       result = Stripe::Account.retrieve
# 
#       expect(result.object).to eq("account")
#     end
#   end
# 
#   describe "POST /v1/accounts/:account_id" do
#     it "returns an account response" do
#       account = Stripe::Account.new(id: "account-id")
#       account.email = "jennifer@example.com"
# 
#       result = account.save
# 
#       expect(result.object).to eq("account")
#     end
#   end
# 
#   describe "POST /v1/accounts" do
#     it "returns an account response" do
#       result = Stripe::Account.create
# 
#       expect(result.object).to eq("account")
#     end
#   end
# 
#   describe 'POST /v1/charges' do
#     it 'returns a fake charge response' do
#       result = Stripe::Charge.create
# 
#       expect(result.paid).to eq true
#     end
# 
#     it 'increments the charge counter' do
#       expect do
#         Stripe::Charge.create
#       end.to change(FakeStripe, :charge_count).by(1)
#     end
# 
#     context 'with an invalid amount' do
#       it 'returns an error' do
#         expect do
#           Stripe::Charge.create(amount: -100)
#         end.to raise_error(Stripe::InvalidRequestError)
#       end
# 
#       it 'does not increment the charge counter' do
#         expect do
#           begin
#             Stripe::Charge.create(amount: 0)
#           rescue Stripe::InvalidRequestError
#           end
#         end.not_to change(FakeStripe, :charge_count)
#       end
#     end
#   end
# 
#   describe 'POST /v1/refunds' do
#     it 'returns a fake refund response' do
#       result = Stripe::Refund.create(charge: 'ABC123')
# 
#       expect(result.refunded).to eq true
#     end
# 
#     it 'increments the refund counter' do
#       expect do
#         Stripe::Refund.create(charge: 'ABC123')
#       end.to change(FakeStripe, :refund_count).by(1)
#     end
#   end
# 
#   describe 'POST /v1/charges/:charge_id/refund' do
#     it 'returns a fake refund response' do
#       result = Stripe::Charge.retrieve('ABC123').refund
# 
#       expect(result.refunded).to eq true
#     end
# 
#     it 'increments the refund counter' do
#       expect do
#         Stripe::Charge.retrieve('ABC123').refund
#       end.to change(FakeStripe, :refund_count).by(1)
#     end
#   end
# 
#   describe "POST /v1/customers" do
#     it "increments the customer counter" do
#       expect do
#         Stripe::Customer.create
#       end.to change(FakeStripe, :customer_count).by(1)
#     end
#   end
# 
#   describe "POST /v1/customers/:customer_id/sources" do
#     it "increments the card counter" do
#       customer = Stripe::Customer.retrieve("ABC123")
# 
#       expect do
#         customer.sources.create(card: "xyz890")
#       end.to change(FakeStripe, :card_count).by(1)
#     end
#   end
# 
#   describe "POST /v1/customers/:customer_id/subscriptions" do
#     it "increments the subscription counter" do
#       customer = Stripe::Customer.retrieve("ABC123")
# 
#       expect do
#         customer.subscriptions.create(plan: "xyz890")
#       end.to change(FakeStripe, :subscription_count).by(1)
#     end
#   end
# 
#   describe "POST /v1/plans" do
#     it "increments the plan counter" do
#       expect do
#         Stripe::Plan.create
#       end.to change(FakeStripe, :plan_count).by(1)
#     end
#   end
# 
#   describe "POST /v1/coupons" do
#     it "increments the coupon counter" do
#       expect do
#         Stripe::Coupon.create
#       end.to change(FakeStripe, :coupon_count).by(1)
#     end
#   end
# 
#   describe "POST /v1/invoices" do
#     it "increments the invoice counter" do
#       expect do
#         Stripe::Invoice.create
#       end.to change(FakeStripe, :invoice_count).by(1)
#     end
#   end
# 
#   describe "POST /v1/invoiceitems" do
#     it "increments the invoiceitem counter" do
#       expect do
#         Stripe::InvoiceItem.create
#       end.to change(FakeStripe, :invoiceitem_count).by(1)
#     end
#   end
# 
#   describe "POST /v1/transfers" do
#     it "increments the transfer counter" do
#       expect do
#         Stripe::Transfer.create
#       end.to change(FakeStripe, :transfer_count).by(1)
#     end
#   end
# 
#   describe "POST /v1/recipients" do
#     it "increments the recipient counter" do
#       expect do
#         Stripe::Recipient.create
#       end.to change(FakeStripe, :recipient_count).by(1)
#     end
#   end
# 
#   describe "POST /v1/tokens" do
#     context "when bank account is provided" do
#       it "increments the token counter" do
#         expect do
#           Stripe::Token.create(bank_account: "bank_account")
#         end.to change(FakeStripe, :token_count).by(1)
#       end
# 
#       it "returns a bank account token" do
#         result = Stripe::Token.create(bank_account: "bank_account")
# 
#         expect(result.type).to eq FakeStripe::BANK_ACCOUNT_OBJECT_TYPE
#       end
#     end
# 
#     context "when bank account is not provided" do
#       it "increments the token counter" do
#         expect do
#           Stripe::Token.create
#         end.to change(FakeStripe, :token_count).by(1)
#       end
# 
#       it "returns a card token" do
#         result = Stripe::Token.create
# 
#         expect(result.type).to eq FakeStripe::CARD_OBJECT_TYPE
#       end
#     end
#   end
# end
describe FakeStripe::StubApp, 'POST /v1/charges' do
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
  end
end
