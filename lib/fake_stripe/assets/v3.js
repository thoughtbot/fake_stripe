class StripeElement {
  mount(el) {
    if (typeof el === "string") {
      el = document.querySelector(el);
    }

    el.innerHTML = `
      <input name="cardnumber" placeholder="cardnumber" size="16" type="text">
      <input placeholder="exp-date" size="6" type="text">
      <input placeholder="cvc" size="3" type="text">
      <input placeholder="postal" size="6" type="text">
    `;
  }

  addEventListener() {}
}

window.Stripe = () => {
  const fetchLastFour = () => {
    return document.getElementById("stripe-cardnumber").value.substr(-4, 4);
  };

  return {
    elements: () => {
      return {
        create: (type, options) => new StripeElement()
      };
    },

    createToken: card => {
      return new Promise(resolve => {
        resolve({ token: { id: "tok_123", card: { last4: fetchLastFour() } } });
      });
    },

    confirmCardSetup: () => {
      const cardNumber = document.querySelector('input[name="cardnumber"]').value

      if (cardNumber === '4000000000000002') {
        return Promise.reject({});
      }

      return Promise.resolve({});
    }
  };
};
