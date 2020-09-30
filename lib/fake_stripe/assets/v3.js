class Element {
  constructor(type, options) {
    this.type = type;
    this.options = options;
  }

  mount(el) {
    if (typeof el === "string") {
      el = document.querySelector(el);
    }
    console.log("Here!!!!!!!" + this.type)
    if(this.type === "cardNumber") {
      el.innerHTML = `
        <div class="credit-card-response__card StripeElement StripeElement--empty" data-placeholder="Card Number">
          <div class="__PrivateStripeElement" style="margin: 0px !important; padding: 0px !important; border: medium none !important; display: block !important; background: transparent none repeat scroll 0% 0% !important; position: relative !important; opacity: 1 !important;">
            <input placeholder="Card Number" scrolling="no" id="stripe-cardnumber" name="cardnumber" allowpaymentrequest="true" style="border: medium none !important; margin: 0px !important; padding: 0px !important; width: 1px !important; min-width: 100% !important; overflow: hidden !important; display: block !important; user-select: none !important; height: 19.2px;" frameborder="0">
          </div>
        </div>
      `;
    } else if(this.type === "cardExpiry") {
      el.innerHTML =  `
        <div data-placeholder="MM/YY" class="StripeElement StripeElement--empty">
          <div class="__PrivateStripeElement" style="margin: 0px !important; padding: 0px !important; border: medium none !important; display: block !important; background: transparent none repeat scroll 0% 0% !important; position: relative !important; opacity: 1 !important;">
            <input placeholder="MM/YY" allowtransparency="true" scrolling="no" name="exp-date" allowpaymentrequest="true" style="border: medium none !important; margin: 0px !important; padding: 0px !important; width: 1px !important; min-width: 100% !important; overflow: hidden !important; display: block !important; user-select: none !important; height: 19.2px;" frameborder="0">
          </div>
        </div>
      `
    } else if(this.type === "cardCvc") {
      el.innerHTML = `
        <div data-target="donations.cvc" data-placeholder="CVC" class="StripeElement StripeElement--empty">
          <div class="__PrivateStripeElement" style="margin: 0px !important; padding: 0px !important; border: medium none !important; display: block !important; background: transparent none repeat scroll 0% 0% !important; position: relative !important; opacity: 1 !important;">
            <input autocomplete="cc-csc" autocorrect="off" spellcheck="false" type="tel" name="cvc" aria-label="Credit or debit card CVC/CVV" placeholder="CVC" aria-invalid="false" value="" scrolling="no" allowpaymentrequest="true" style="border: medium none !important; margin: 0px !important; padding: 0px !important; width: 1px !important; min-width: 100% !important; overflow: hidden !important; display: block !important; user-select: none !important; height: 19.2px;" frameborder="0">
          </div>
        </div>
      `
    } else if (this.type === "postalCode") {
      el.innerHTML = `
        <div data-target="donations.postalCode" data-placeholder="ZIP" class="StripeElement StripeElement--empty">
          <div class="__PrivateStripeElement" style="margin: 0px !important; padding: 0px !important; border: medium none !important; display: block !important; background: transparent none repeat scroll 0% 0% !important; position: relative !important; opacity: 1 !important;">
            <input autocomplete="postal-code" autocorrect="off" spellcheck="false" type="text" name="postal" aria-label="Postal code" placeholder="ZIP" aria-invalid="false" value="" allowpaymentrequest="true" style="border: medium none !important; margin: 0px !important; padding: 0px !important; width: 1px !important; min-width: 100% !important; overflow: hidden !important; display: block !important; user-select: none !important; height: 19.2px;" frameborder="0">
          </div>
        </div>
      `
    }
  }
}

window.Stripe = () => {
  const fetchLastFour = () => {
    return document.getElementById("stripe-cardnumber").value.substr(-4, 4);
  };

  const errorMessage = () => {
    if (document.getElementById("stripe-cardnumber").value === "") {
      return "Your card number is incomplete";
    } else if (document.getElementById("stripe-cardnumber").value === "4242424242424241") {
      return "Your card number is invalid.";
    } else { 
      return null; 
    }
  }

  return {
    elements: () => {
      return {
        create: (type, options) => new Element(type, options)
      };
    },

    createToken: card => {
      return new Promise(resolve => {
        if (errorMessage() == null) {
          resolve({ token: { id: "tok_123", card: { last4: fetchLastFour() } } });
        } else { 
          resolve({ error: { message: errorMessage() } });
        }
      });
    }
  };
};
