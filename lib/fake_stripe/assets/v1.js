window.Stripe = {
  createToken: function(creditCard, handler) {
    function isValidCardNumber(number) {
      var validCardNumbers = ['4242424242424242', '4242 4242 4242 4242'];
      return $.inArray(number, validCardNumbers) >= 0;
    }

    if (isValidCardNumber(creditCard.number)) {
      handler(200, {
        id: 123,
        card: {
          last4: 4242,
          type: 'Visa',
          exp_month: '12',
          exp_year: '2018'
        }
      });
    } else {
      handler(402, {
        error: {
          code: 'incorrect_number',
          message: 'Your card number is incorrect',
          param: 'number',
          type: 'card_error'
        }
      });
    }
  },
  cardType: function(value) { return 'Visa' },
  setPublishableKey: function() {},
  validateCardNumber: function(value) { return true; },
  validateCVC: function(value) { return true; },
  validateExpiry: function(value) { return true; }
};
