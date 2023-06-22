class StripeElement {
  constructor(type, options) {
    this.type = type;
    this.element = null;
    this.options = options;
    this.callbacks = {};
  }

  mount(el) {
    if (typeof el === "string") {
      el = document.querySelector(el);
    }
    const styles = this._prepareStyles();
    console.log("Here!!!!!!!" + this.type);

    if(this.type === "cardNumber") {
      el.innerHTML = `
        <style>${styles}</style>
        <div class="credit-card-response__card StripeElement StripeElement--empty">
          <div class="__PrivateStripeElement" style="margin: 0px !important; padding: 0px !important; border: medium none !important; display: block !important; background: transparent none repeat scroll 0% 0% !important; position: relative !important; opacity: 1 !important;">
            <input placeholder="Card Number" scrolling="no" id="stripe-cardNumber" name="cardnumber" allowpaymentrequest="true" style="box-shadow: none; border: medium none !important; margin: 0px !important; padding: 0px !important; width: 1px !important; min-width: 100% !important; overflow: hidden !important; display: block !important; user-select: none !important; height: 19.2px;" frameborder="0">
          </div>
        </div>
      `;
    } else if(this.type === "cardExpiry") {
      el.innerHTML =  `
        <style>${styles}</style>
        <div data-placeholder="MM/YY" class="StripeElement StripeElement--empty">
          <div class="__PrivateStripeElement" style="margin: 0px !important; padding: 0px !important; border: medium none !important; display: block !important; background: transparent none repeat scroll 0% 0% !important; position: relative !important; opacity: 1 !important;">
            <input id="stripe-cardExpiry" placeholder="MM/YY" allowtransparency="true" scrolling="no" name="exp-date" allowpaymentrequest="true" style="box-shadow: none; border: medium none !important; margin: 0px !important; padding: 0px !important; width: 1px !important; min-width: 100% !important; overflow: hidden !important; display: block !important; user-select: none !important; height: 19.2px;" frameborder="0">
          </div>
        </div>
      `
    } else if(this.type === "cardCvc") {
      el.innerHTML = `
        <style>${styles}</style>
        <div data-target="donations.cvc" data-placeholder="CVC" class="StripeElement StripeElement--empty">
          <div class="__PrivateStripeElement" style="margin: 0px !important; padding: 0px !important; border: medium none !important; display: block !important; background: transparent none repeat scroll 0% 0% !important; position: relative !important; opacity: 1 !important;">
            <input id="stripe-cardCvc" autocomplete="cc-csc" autocorrect="off" spellcheck="false" type="tel" name="cvc" aria-label="Credit or debit card CVC/CVV" placeholder="CVC" aria-invalid="false" value="" scrolling="no" allowpaymentrequest="true" style="box-shadow: none; border: medium none !important; margin: 0px !important; padding: 0px !important; width: 1px !important; min-width: 100% !important; overflow: hidden !important; display: block !important; user-select: none !important; height: 19.2px;" frameborder="0">
          </div>
        </div>
      `
    } else if (this.type === "postalCode") {
      el.innerHTML = `
        <style>${styles}</style>
        <div data-target="donations.postalCode" data-placeholder="ZIP" class="StripeElement StripeElement--empty">
          <div class="__PrivateStripeElement" style="margin: 0px !important; padding: 0px !important; border: medium none !important; display: block !important; background: transparent none repeat scroll 0% 0% !important; position: relative !important; opacity: 1 !important;">
            <input id="stripe-postalCode" autocomplete="postal-code" autocorrect="off" spellcheck="false" type="text" name="postal" aria-label="Postal code" placeholder="ZIP" aria-invalid="false" value="" allowpaymentrequest="true" style="box-shadow: none;border: medium none !important; margin: 0px !important; padding: 0px !important; width: 1px !important; min-width: 100% !important; overflow: hidden !important; display: block !important; user-select: none !important; height: 19.2px;" frameborder="0">
          </div>
        </div>
      `
    }

    this.element = el.querySelector("input");

    if (this.callbacks.ready) {
      this.callbacks.ready(this.element);
    }

    this.element.addEventListener('change', (event) => {
      if (this.type === 'cardNumber') {
        if (event.currentTarget.value === "") {
          this.callCallback('change')({
            ...event,
            empty: true,
            complete: false,
            error: { message: "Your card number is incomplete" },
          });
          return;
        } else if (event.currentTarget.value === "4242424242424241") {
          this.callCallback('change')({
            ...event,
            empty: false,
            completed: true,
            error: { message: "Your card number is invalid." },
          });
          return;
        } else {
          this.callCallback('change')({
            ...event,
            empty: event.currentTarget.value === "",
            complete: event.currentTarget.value.length > 15,
          });
          return;
        }
      }

      this.callCallback('change')({
        ...event,
        empty: event.currentTarget.value === "",
        complete: event.currentTarget.value.length !== "",
      });
    });
    this.element.addEventListener('focus', this.callCallback('focus'));
    this.element.addEventListener('blur', this.callCallback('blur'));
    this.element.addEventListener('click', this.callCallback('click'));
  }

  on(type, callback) {
    console.log(`Callback provided for "${type}"`);
    this.callbacks[type] = callback;

    if (type === 'ready' && this.element) {
      callback(this.element);
    }
  }

  callCallback(eventType) {
    return (event) => {
      if (this.callbacks[eventType]) {
        this.callbacks[eventType](event);
      }
    }
  }

  destroy() {
    // Cleanup logic here
    // Remove event listeners, clear DOM, etc.
    this.element.removeEventListener('change', this.callCallback('change'));
    this.element.removeEventListener('focus', this.callCallback('focus'));
    this.element.removeEventListener('blur', this.callCallback('blur'));
    this.element.removeEventListener('click', this.callCallback('click'));

    // Clear the DOM element
    if (this.element.parentNode) {
      this.element.parentNode.removeChild(this.element);
    }

    // Set the instance variables to null
    this.element = null;
    this.callbacks = {};
  }

  focus() {
    this.element.focus();
  }

  _prepareStyles() {
    if (!this.options || !this.options.style || !this.options.style.base) {
      return '';
    }

    const base = this.options.style.base;
    const withoutPrefix = {};
    const withPrefix = {};
    const prefixed = [];

    for (const key of Object.keys(base)) {
      if (key.startsWith("::")) {
        withPrefix[key] = base[key];
      } else {
        withoutPrefix[key] = base[key];
      }
    }

    for (const key of Object.keys(withPrefix)) {
      prefixed.push(`#stripe-${this.type}${key} { ${this._makeStylesFor(withPrefix[key])} }`)
    }

    return `
      #stripe-${this.type} {
        ${this._makeStylesFor(withoutPrefix)}
      }

      ${prefixed.join("\n")}
    `;
  }

  _makeStylesFor(obj) {
    const styles = [];

    for (const key of Object.keys(obj)) {
      styles.push(`${this._toKebabCase(key)}: ${obj[key]} !important;`);
    }

    return styles.join("\n");
  }

  _toKebabCase(str) {
    return str.split('').map((letter, idx) => {
      return letter.toUpperCase() === letter
        ? `${idx !== 0 ? '-' : ''}${letter.toLowerCase()}`
        : letter;
    }).join('');
  }
}

window.Stripe = () => {
  const elements = {};

  const fetchLastFour = () => {
    return document.getElementById("stripe-cardNumber").value.substr(-4, 4);
  };

  const errorMessage = () => {
    if (document.getElementById("stripe-cardNumber").value === "") {
      return "Your card number is incomplete";
    } else if (document.getElementById("stripe-cardNumber").value === "4242424242424241") {
      return "Your card number is invalid.";
    } else {
      return null;
    }
  }

  return {
    elements: () => {
      return {
        create: (type, options) => { elements[type] = new StripeElement(type, options); return elements[type]; },
        getElement: (type) => elements[type.__elementType || type],
      };
    },

    createToken: (card) => {
      return new Promise(resolve => {
        if (errorMessage() == null) {
          resolve({ token: { id: "tok_123", card: { last4: fetchLastFour() } } });
        } else {
          resolve({ error: { message: errorMessage() } });
        }
      });
    },

    createPaymentMethod: (options) => {
      return new Promise((resolve, reject) => {
        if (options.type === 'card') {
          cardNumber = options.card.element.value.replace(/\s+/g, '');
          last4 = cardNumber.slice(-4);
          if (cardNumber === '4242424242424242') {
            resolve({
              paymentMethod: { type: 'card', card: { brand: 'Visa', funding: "credit", last4: last4 }  }
            });
          } else if (cardNumber === '5200828282828210') {
            resolve({
              paymentMethod: { type: 'card', card: { brand: 'Mastercard', funding: "debit", last4: last4 }  }
            });
          } else if (cardNumber === '5105105105105100') {
            resolve({
              paymentMethod: { type: 'card', card: { brand: 'Mastercard', funding: "prepaid", last4: last4 }  }
            });
          } else {
            resolve({
              paymentMethod: { type: 'card', card: { brand: 'Visa', funding: "unknown", last4: last4 }  }
            });
          }
        }
      });
    },

    confirmCardPayment: (client_secret, options) => {
      // the values of these constants are replaced when the script is rendered
      const api_key = 'sk_test_key';
      const api_host = 'https://api.stripe.com';
      const stripe_acct = 'acct_123';
      const payment_intent_id =  client_secret.match(/^(.*?)(?:_secret.*)?$/)[1];

      return new Promise((resolve, reject) => {
        const body = new URLSearchParams();
        body.append('_stripe_account', stripe_acct);
        body.append('type', 'card');

        const createPaymentMethod = () => {
          return fetch(api_host + '/v1/payment_methods', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded',
              'Authorization': 'Basic ' + btoa(api_key + ':')
            },
            body: body
          }).then(response => response.json());
        };

        const confirmPaymentIntent = (payment_method, options) => {
          const body = new URLSearchParams(options);
          body.append('_stripe_account', stripe_acct);
          body.append('client_secret', client_secret);
          body.append('payment_method', payment_method.id);
          body.append('expand[]', 'payment_method');

          return fetch(api_host + '/v1/payment_intents/' + payment_intent_id + '/confirm', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded',
              'Authorization': 'Basic ' + btoa(api_key + ':')
            },
            body: body,
          }).then(response => response.json());
        };

        createPaymentMethod()
        .then(paymentMethod => confirmPaymentIntent(paymentMethod, options))
        .then(json => {
          if (!json.error) {
            resolve({
              paymentIntent: json,
              paymentMethod: json['payment_method'],
            });
          } else {
            resolve({
              error: json.error,
            });
          }
        })
        .catch(error => {
          reject(error);
        });
      });
    },

    collectBankAccountForPayment: (client_secret, options) => {
      const api_key = 'sk_test_key';
      const api_host = 'https://api.stripe.com';
      const stripe_acct = 'acct_123';
      const payment_intent_id = client_secret.clientSecret.match(/^(.*?)(?:_secret.*)?$/)[1];

      return new Promise((resolve, reject) => {
        const body = new URLSearchParams();
        body.append('_stripe_account', stripe_acct);
        body.append('type', 'us_bank_account');
        const createPaymentMethod = () => {
          return fetch(api_host + '/v1/payment_methods', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded',
              'Authorization': 'Basic ' + btoa(api_key + ':')
            },
            body: body
          }).then(response => response.json());
        };

        const updatePaymentIntent = (payment_method) => {
          const body = new URLSearchParams();
          body.append('_stripe_account', stripe_acct);
          body.append('client_secret', client_secret.clientSecret);
          body.append('payment_method', payment_method.id);
          body.append('expand[]', 'payment_method');

          return fetch(api_host + '/v1/payment_intents/' + payment_intent_id, {
            method: 'POST',
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded',
              'Authorization': 'Basic ' + btoa(api_key + ':')
            },
            body: body,
          }).then(response => response.json());
        };

        createPaymentMethod()
        .then(paymentMethod => updatePaymentIntent(paymentMethod))
        .then(json => {
          if (!json.error) {
            resolve({
              paymentIntent: json,
              paymentMethod: json['payment_method'],
            });
          } else {
            resolve({
              error: json.error,
            });
          }
        })
        .catch(error => {
          reject(error);
        });
      });
    },


    confirmUsBankAccountPayment: (client_secret, options) => {
      // the values of these constants are replaced when the script is rendered
      const api_key = 'sk_test_key';
      const api_host = 'https://api.stripe.com';
      const stripe_acct = 'acct_123';
      const payment_intent_id =  client_secret.match(/^(.*?)(?:_secret.*)?$/)[1];
      const body = new URLSearchParams(options);
      body.append('_stripe_account', stripe_acct);
      body.append('client_secret', client_secret);
			body.append('payment_method', "pm_usBankAccount_success");

      return new Promise((resolve, reject) => {
        fetch(api_host  + '/v1/payment_intents/' + payment_intent_id + '/confirm', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Authorization': 'Basic ' + btoa(api_key + ':')
          },
          body: body,
        }).then(response => response.json()).then((json) => {
          if(!json.error) {
            resolve({
              paymentIntent: json,
            });
          } else {
            resolve({
              error: json.error,
            });
          }
        }).catch((error) => {
          reject(error);
        });
      });
    }
  };
};
