module FakeStripe
  class Charge < Struct.new(:owned_card_ids, :params)
    def valid?
      customer_id.nil? || owned_card_ids.include?(card_id)
    end

    def response
      {
        amount: amount,
        customer: customer_id,
        card: {
          id: card_id,
          address_city: nil,
          address_country: nil,
          address_line1: nil,
          address_line1_check: nil,
          address_line2: nil,
          address_state: nil,
          address_zip: nil,
          address_zip_check: nil,
          country: "US",
          cvc_check: "pass",
          exp_month: 11,
          exp_year: 2014,
          fingerprint: "qhjxpr7DiCdFYTlH",
          last4: "4242",
          name: "john doe",
          object: "card",
          type: "Visa"
        },
        amount_refunded: 0,
        created: 1360691193,
        currency: "usd",
        description: "Polygonian licensing",
        dispute: nil,
        failure_message: nil,
        fee: 59,
        fee_details: [
          {
            amount: 59,
            application: nil,
            currency: "usd",
            description: "Stripe processing fees",
            type: "stripe_fee"
          }
        ],
        id: "ch_1HLqBx9AyixBof",
        invoice: nil,
        livemode: false,
        object: "charge",
        paid: true,
        refunded: false
      }
    end

    def error
      {
        error: {
          type: "invalid_request_error",
          message: "Customer #{customer_id} does not have card with ID #{card_id}",
          param: "card"
        }
      }
    end

    private

    def customer_id
      params[:customer]
    end

    def card_id
      params[:card]
    end

    def amount
      params[:amount].to_i
    end
  end
end
