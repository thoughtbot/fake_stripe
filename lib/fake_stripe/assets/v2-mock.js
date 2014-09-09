(function() {
  this.Stripe.ajaxJSONP = function(options) {
    if (options.url.indexOf("tokens") > -1) {
      return options.success({
        id: 123,
        card: {
          last4: 4242,
          brand: 'Visa',
          exp_month: '12',
          exp_year: '2018'
        }
      }, 200);
    } else {
      throw(options.url + " has not been mocked by FakeStripe. " +
        "Please submit a pull request to implement this action.");
    }
  };
}).call(this);
