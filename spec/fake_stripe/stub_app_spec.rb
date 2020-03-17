require 'spec_helper'

describe FakeStripe::StubApp do
  # Accounts
  describe "POST /v1/accounts" do
    it "returns an account response" do
      result = Stripe::Account.create

      expect(result.object).to eq("account")
    end
  end
  describe "GET /v1/accounts/:account_id" do
    it "returns an account response" do
      result = Stripe::Account.retrieve("stripe-account-id")

      expect(result.object).to eq("account")
    end
  end

  describe "GET /v1/account" do
    it "returns an account response" do
      result = Stripe::Account.retrieve

      expect(result.object).to eq("account")
    end
  end

  describe "POST /v1/accounts/:account_id" do
    it "returns an account response" do
      account = Stripe::Account.new(id: "account-id")
      account.email = "jennifer@example.com"

      result = account.save

      expect(result.object).to eq("account")
    end
  end

  # Terminal
  describe "POST v1/terminal/connection_tokens" do
    it "returns a connection token" do
      result = Stripe::Terminal::ConnectionToken.create

      expect(result.object).to eq("terminal.connection_token")
    end
  end

  # Reader Locations
  describe "POST v1/terminal/locations" do
    it "create a reader location" do
      result = Stripe::Terminal::Location.create

      expect(result.object).to eq("terminal.location")
    end
  end

  describe "GET v1/terminal/locations/:id" do
    it "returns a reader location" do
      result = Stripe::Terminal::Location.retrieve("tml_GiFc2v8I36CRIgseZN5iD7bY")

      expect(result.object).to eq("terminal.location")
    end
  end

  describe "POST v1/terminal/locations/:id" do
    it "updates a reader location" do
      result = Stripe::Terminal::Location.update("tml_GiFc2v8I36CRIgseZN5iD7bY", { label: "main reader"})

      expect(result.object).to eq("terminal.location")
    end
  end

  describe "DELETE v1/terminal/locations/:id" do
    it "deletes a reader location" do
      result = Stripe::Terminal::Location.delete("tml_GiFc2v8I36CRIgseZN5iD7bY")

      expect(result.object).to eq("terminal.location")
    end
  end

  describe "GET /v1/terminal/locations" do
    it "returns a list of a customers payment methods" do
      result = Stripe::Terminal::Location.list({
        limit: 100,
      })

      expect(result.count).to eq(3)
      expect(result.first.object).to eq("terminal.location")
    end
  end

  # Readers

  describe "POST v1/terminal/readeers" do
    it "create a reader" do
      result = Stripe::Terminal::Reader.create

      expect(result.object).to eq("terminal.reader")
    end
  end

  describe "GET v1/terminal/readers/:id" do
    it "returns a reader" do
      result = Stripe::Terminal::Reader.retrieve("tmr_P400-123-456-789")

      expect(result.object).to eq("terminal.reader")
    end
  end

  describe "POST v1/terminal/readers/:id" do
    it "updates a reader" do
      result = Stripe::Terminal::Reader.update("tmr_P400-123-456-789", { label: "main reader"})

      expect(result.object).to eq("terminal.reader")
    end
  end

  describe "DELETE v1/terminal/readers/:id" do
    it "deletes a reader location" do
      result = Stripe::Terminal::Reader.delete("tmr_P400-123-456-789")

      expect(result.object).to eq("terminal.reader")
    end
  end

  describe "GET /v1/terminal/locations" do
    it "returns a list of a customers payment methods" do
      result = Stripe::Terminal::Location.list({
        limit: 100,
      })

      expect(result.count).to eq(3)
      expect(result.first.object).to eq("terminal.location")
    end
  end

  # Setup Intents
  describe "POST v1/setup_intents" do
    it "returns a setup intent" do
      result = Stripe::SetupIntent.create

      expect(result.object).to eq("setup_intent")
    end
  end
  describe "GET v1/setup_intents/:id" do
    it "returns a setup intent" do
      result = Stripe::SetupIntent.create

      expect(result.object).to eq("setup_intent")
    end
  end

  describe "POST v1/setup_intents/:id/confirm" do
    it "confirms a setup intent" do
      setup_intent = Stripe::SetupIntent.create
      result = Stripe::SetupIntent.confirm(setup_intent.id)

      expect(result.object).to eq("setup_intent")
    end
  end

  describe "POST v1/setup_intents/:id/cancel" do
    it "cancels a setup intent" do
      setup_intent = Stripe::SetupIntent.create
      result = Stripe::SetupIntent.cancel(setup_intent.id)

      expect(result.object).to eq("setup_intent")
      expect(result.status).to eq("canceled")
    end
  end

  describe "GET /v1/setup_intents" do
    it "returns a list of a setup intents" do
      results = Stripe::SetupIntent.list({
        limit: 100,
      })

      expect(results.count).to eq(3)
      results.each do |result|
        expect(result.object).to eq("setup_intent")
      end
    end
  end

  # Payment Intents
  describe "POST v1/payment_intents" do
    it "returns a payment intent" do
      params = {
        amount: 10000,
        payment_method_types: ["card_present"],
        capture_method: "manual",
        on_behalf_of: Stripe::Account.create.id,
        statement_descriptor: "Demo University",
        metadata: {
          category_id: 1,
          contribution_id: 1,
          project_id: 1,
          payer_name: "Frank Sinatra",
          payer_email: "frank@example.com"
        },
        transfer_data: {
          destination: "acct_1A1xvnHNvvp0Twf9",
          currency: "USD"
        }
      }
      result = Stripe::PaymentIntent.create(params)

      expect(result.object).to eq("payment_intent")
    end
  end

  describe "GET v1/payment_intents/:payment_intent_id" do
    it "returns a payment intent" do
      result = Stripe::PaymentIntent.create

      expect(result.object).to eq("payment_intent")
    end
  end

  describe "POST v1/payment_intents/:payment_intent_id/confirm" do
    it "confirms a payment intent" do
      payment_intent = Stripe::PaymentIntent.create
      result = Stripe::PaymentIntent.confirm(payment_intent.id)

      expect(result.object).to eq("payment_intent")
    end
  end

  describe "POST v1/payment_intents/:payment_intent_id/capture" do
    it "captures a payment intent" do
      payment_intent = Stripe::PaymentIntent.create
      result = Stripe::PaymentIntent.capture(payment_intent.id)

      expect(result.charges.data.first.object).to eq("charge")
    end
  end

  # Refunds
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

    context 'with an invalid amount' do
      it 'returns an error' do
        expect do
          Stripe::Charge.create(amount: -100)
        end.to raise_error(Stripe::InvalidRequestError)
      end

      it 'does not increment the charge counter' do
        expect do
          begin
            Stripe::Charge.create(amount: 0)
          rescue Stripe::InvalidRequestError
          end
        end.not_to change(FakeStripe, :charge_count)
      end
    end
  end

  # Refunds
  describe 'POST /v1/refunds' do
    it 'returns a fake refund response' do
      result = Stripe::Refund.create(charge: 'ABC123')

      expect(result.refunded).to eq true
    end

    it 'increments the refund counter' do
      expect do
        Stripe::Refund.create(charge: 'ABC123')
      end.to change(FakeStripe, :refund_count).by(1)
    end
  end

  # Customers
  describe "POST /v1/customers" do
    it "increments the customer counter" do
      expect do
        Stripe::Customer.create
      end.to change(FakeStripe, :customer_count).by(1)
    end
  end

  describe "POST /v1/customers/:customer_id/sources" do
    it "increments the card counter" do
      customer = Stripe::Customer.retrieve("ABC123")

      expect do
        customer.sources.create(card: "xyz890")
      end.to change(FakeStripe, :card_count).by(1)
    end
  end

  # Subscriptions
  describe "POST /v1/customers/:customer_id/subscriptions" do
    it "increments the subscription counter" do
      customer = Stripe::Customer.retrieve("ABC123")

      expect do
        customer.subscriptions.create(plan: "xyz890")
      end.to change(FakeStripe, :subscription_count).by(1)
    end
  end

  # Payment Methods
  describe "POST /v1/payment_methods" do
    it "increments the card counter" do
      expect do
        payment_method = Stripe::PaymentMethod.create({
          type: "card",
          card: {
            number: "4242424242424242",
            exp_month: "1",
            exp_year: "2028",
            cvc: "321",
          }
        })
      end.to change(FakeStripe, :card_count).by(1)
    end
  end

  describe "GET /v1/payment_methods/:payment_method_id" do
    it "returns a payment method" do
      result = Stripe::PaymentMethod.create
      expect(result.object).to eq("payment_method")
    end
  end

  describe "POST /v1/payment_methods/:payment_method_id" do
    it "updates a payment method" do
      payment_method = Stripe::PaymentMethod.create
      result = Stripe::PaymentMethod.update(
        payment_method.id,
        {exp_year: "2024"},
      )

      expect(result.object).to eq("payment_method")
    end
  end

  describe "GET /v1/payment_methods" do
    it "returns a list of a customers payment methods" do
      result = Stripe::PaymentMethod.list({
        customer: Stripe::Customer.create.id,
        type: "card",
      })

      expect(result.count).to eq(1)
      expect(result.first.object).to eq("payment_method")
    end
  end

  describe "POST /v1/payment_methods/:payment_method_id/attach" do
    it "attaches a payment method to a customer" do
      customer = Stripe::Customer.create
      payment_method = Stripe::PaymentMethod.create

      result = Stripe::PaymentMethod.attach(
        payment_method.id,
        {customer: customer.id},
      )

      expect(result.object).to eq("payment_method")
    end
  end

  describe "POST /v1/payment_methods/:payment_method_id/dettach" do
    it "attaches a payment method to a customer" do
      customer = Stripe::Customer.create
      payment_method = Stripe::PaymentMethod.create

      result = Stripe::PaymentMethod.detach(
        payment_method.id,
      )

      expect(result.object).to eq("payment_method")
    end
  end

  # Plans
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
    context "when bank account is provided" do
      it "increments the token counter" do
        expect do
          Stripe::Token.create(bank_account: "bank_account")
        end.to change(FakeStripe, :token_count).by(1)
      end

      it "returns a bank account token" do
        result = Stripe::Token.create(bank_account: "bank_account")

        expect(result.type).to eq FakeStripe::BANK_ACCOUNT_OBJECT_TYPE
      end
    end

    context "when bank account is not provided" do
      it "increments the token counter" do
        expect do
          Stripe::Token.create
        end.to change(FakeStripe, :token_count).by(1)
      end

      it "returns a card token" do
        result = Stripe::Token.create

        expect(result.type).to eq FakeStripe::CARD_OBJECT_TYPE
      end
    end
  end
end
