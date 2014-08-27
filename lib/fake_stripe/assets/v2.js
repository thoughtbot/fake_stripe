(function() {
  var Stripe, exports, key, _i, _len,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    _this = this;

  this.Stripe = (function() {

    function Stripe() {}

    Stripe.version = 2;

    Stripe.endpoint = 'https://api.stripe.com/v1';

    Stripe.setPublishableKey = function(key) {
      Stripe.key = key;
    };

    Stripe.complete = function(callback, errorMessage) {
      return function(type, xhr, options) {
        var timestamp;
        if (type !== 'success') {
          timestamp = Math.round(new Date().getTime() / 1000);
          (new Image).src = "https://q.stripe.com?event=stripejs-error&type=" + type + "&key=" + Stripe.key + "&timestamp=" + timestamp;
          return typeof callback === "function" ? callback(500, {
            error: {
              code: type,
              type: type,
              message: errorMessage
            }
          }) : void 0;
        }
      };
    };

    return Stripe;

  }).call(this);

  Stripe = this.Stripe;

  this.Stripe.token = (function() {

    function token() {}

    token.validate = function(data, name) {
      if (!data) {
        throw name + ' required';
      }
      if (typeof data !== 'object') {
        throw name + ' invalid';
      }
    };

    token.formatData = function(data, attrs) {
      if (Stripe.utils.isElement(data)) {
        data = Stripe.utils.paramsFromForm(data, attrs);
      }
      Stripe.utils.underscoreKeys(data);
      return data;
    };

    token.create = function(params, callback) {
      params.key || (params.key = Stripe.key || Stripe.publishableKey);
      Stripe.utils.validateKey(params.key);
      return Stripe.ajaxJSONP({
        url: "" + Stripe.endpoint + "/tokens",
        data: params,
        method: 'POST',
        success: function(body, status) {
          return typeof callback === "function" ? callback(status, body) : void 0;
        },
        complete: Stripe.complete(callback, "A network error has occurred, and you have not been charged. Please try again."),
        timeout: 40000
      });
    };

    token.get = function(token, callback) {
      if (!token) {
        throw 'token required';
      }
      Stripe.utils.validateKey(Stripe.key);
      return Stripe.ajaxJSONP({
        url: "" + Stripe.endpoint + "/tokens/" + token,
        data: {
          key: Stripe.key
        },
        success: function(body, status) {
          return typeof callback === "function" ? callback(status, body) : void 0;
        },
        complete: Stripe.complete(callback, "A network error has occurred loading data from Stripe. Please try again."),
        timeout: 40000
      });
    };

    return token;

  }).call(this);

  this.Stripe.card = (function(_super) {

    __extends(card, _super);

    function card() {
      return card.__super__.constructor.apply(this, arguments);
    }

    card.tokenName = 'card';

    card.whitelistedAttrs = ['number', 'cvc', 'exp_month', 'exp_year', 'name', 'address_line1', 'address_line2', 'address_city', 'address_state', 'address_zip', 'address_country'];

    card.createToken = function(data, params, callback) {
      var amount;
      if (params == null) {
        params = {};
      }
      Stripe.token.validate(data, 'card');
      if (typeof params === 'function') {
        callback = params;
        params = {};
      } else if (typeof params !== 'object') {
        amount = parseInt(params, 10);
        params = {};
        if (amount > 0) {
          params.amount = amount;
        }
      }
      params[card.tokenName] = Stripe.token.formatData(data, card.whitelistedAttrs);
      return Stripe.token.create(params, callback);
    };

    card.getToken = function(token, callback) {
      return Stripe.token.get(token, callback);
    };

    card.validateCardNumber = function(num) {
      num = (num + '').replace(/\s+|-/g, '');
      return num.length >= 10 && num.length <= 16 && card.luhnCheck(num);
    };

    card.validateCVC = function(num) {
      num = Stripe.utils.trim(num);
      return /^\d+$/.test(num) && num.length >= 3 && num.length <= 4;
    };

    card.validateExpiry = function(month, year) {
      var currentTime, expiry;
      month = Stripe.utils.trim(month);
      year = Stripe.utils.trim(year);
      if (!/^\d+$/.test(month)) {
        return false;
      }
      if (!/^\d+$/.test(year)) {
        return false;
      }
      if (!(parseInt(month, 10) <= 12)) {
        return false;
      }
      expiry = new Date(year, month);
      currentTime = new Date;
      expiry.setMonth(expiry.getMonth() - 1);
      expiry.setMonth(expiry.getMonth() + 1, 1);
      return expiry > currentTime;
    };

    card.luhnCheck = function(num) {
      var digit, digits, odd, sum, _i, _len;
      odd = true;
      sum = 0;
      digits = (num + '').split('').reverse();
      for (_i = 0, _len = digits.length; _i < _len; _i++) {
        digit = digits[_i];
        digit = parseInt(digit, 10);
        if ((odd = !odd)) {
          digit *= 2;
        }
        if (digit > 9) {
          digit -= 9;
        }
        sum += digit;
      }
      return sum % 10 === 0;
    };

    card.cardType = function(num) {
      return card.cardTypes[num.slice(0, 2)] || 'Unknown';
    };

    card.cardTypes = (function() {
      var num, types, _i, _j;
      types = {};
      for (num = _i = 40; _i <= 49; num = ++_i) {
        types[num] = 'Visa';
      }
      for (num = _j = 50; _j <= 59; num = ++_j) {
        types[num] = 'MasterCard';
      }
      types[34] = types[37] = 'American Express';
      types[60] = types[62] = types[64] = types[65] = 'Discover';
      types[35] = 'JCB';
      types[30] = types[36] = types[38] = types[39] = 'Diners Club';
      return types;
    })();

    return card;

  }).call(this, this.Stripe.token);

  this.Stripe.bankAccount = (function(_super) {

    __extends(bankAccount, _super);

    function bankAccount() {
      return bankAccount.__super__.constructor.apply(this, arguments);
    }

    bankAccount.tokenName = 'bank_account';

    bankAccount.whitelistedAttrs = ['country', 'routing_number', 'account_number'];

    bankAccount.createToken = function(data, params, callback) {
      if (params == null) {
        params = {};
      }
      Stripe.token.validate(data, 'bank account');
      if (typeof params === 'function') {
        callback = params;
        params = {};
      }
      params[bankAccount.tokenName] = Stripe.token.formatData(data, bankAccount.whitelistedAttrs);
      return Stripe.token.create(params, callback);
    };

    bankAccount.getToken = function(token, callback) {
      return Stripe.token.get(token, callback);
    };

    bankAccount.validateRoutingNumber = function(num, country) {
      num = Stripe.utils.trim(num);
      switch (country) {
        case 'US':
          return /^\d+$/.test(num) && num.length === 9 && bankAccount.routingChecksum(num);
        case 'CA':
          return /\d{5}\-\d{3}/.test(num) && num.length === 9;
        default:
          return true;
      }
    };

    bankAccount.validateAccountNumber = function(num, country) {
      num = Stripe.utils.trim(num);
      switch (country) {
        case 'US':
          return /^\d+$/.test(num) && num.length >= 1 && num.length <= 17;
        default:
          return true;
      }
    };

    bankAccount.routingChecksum = function(num) {
      var digits, index, sum, _i, _len, _ref;
      sum = 0;
      digits = (num + '').split('');
      _ref = [0, 3, 6];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        index = _ref[_i];
        sum += parseInt(digits[index]) * 3;
        sum += parseInt(digits[index + 1]) * 7;
        sum += parseInt(digits[index + 2]);
      }
      return sum !== 0 && sum % 10 === 0;
    };

    return bankAccount;

  }).call(this, this.Stripe.token);

  this.Stripe.bitcoinReceiver = (function() {

    function bitcoinReceiver() {}

    bitcoinReceiver._whitelistedAttrs = ['amount', 'currency', 'email', 'description'];

    bitcoinReceiver.createReceiver = function(data, callback) {
      var params;
      Stripe.token.validate(data, 'bitcoin_receiver data');
      params = Stripe.token.formatData(data, this._whitelistedAttrs);
      params.key = Stripe.key || Stripe.publishableKey;
      Stripe.utils.validateKey(params.key);
      return Stripe.ajaxJSONP({
        url: "" + Stripe.endpoint + "/bitcoin/receivers",
        data: params,
        method: 'POST',
        success: function(body, status) {
          return typeof callback === "function" ? callback(status, body) : void 0;
        },
        complete: Stripe.complete(callback, "A network error has occurred while creating a Bitcoin address. Please try again."),
        timeout: 40000
      });
    };

    bitcoinReceiver.getReceiver = function(id, callback) {
      var key;
      if (!id) {
        throw 'receiver id required';
      }
      key = Stripe.key || Stripe.publishableKey;
      Stripe.utils.validateKey(key);
      return Stripe.ajaxJSONP({
        url: "" + Stripe.endpoint + "/bitcoin/receivers/" + id,
        data: {
          key: key
        },
        success: function(body, status) {
          return typeof callback === "function" ? callback(status, body) : void 0;
        },
        complete: Stripe.complete(callback, "A network error has occurred loading data from Stripe. Please try again."),
        timeout: 40000
      });
    };

    bitcoinReceiver._activeReceiverPolls = {};

    bitcoinReceiver._clearReceiverPoll = function(receiverId) {
      return delete bitcoinReceiver._activeReceiverPolls[receiverId];
    };

    bitcoinReceiver._pollInterval = 1500;

    bitcoinReceiver.pollReceiver = function(receiverId, callback) {
      if (this._activeReceiverPolls[receiverId] != null) {
        throw "You are already polling receiver " + receiverId + ". Please cancel that poll before polling it again.";
      }
      this._activeReceiverPolls[receiverId] = {};
      return this._pollReceiver(receiverId, callback);
    };

    bitcoinReceiver._pollReceiver = function(receiverId, callback) {
      bitcoinReceiver.getReceiver(receiverId, function(status, body) {
        var pollInterval, timeoutId;
        if (bitcoinReceiver._activeReceiverPolls[receiverId] == null) {
          return;
        }
        if (status === 200 && body.filled) {
          bitcoinReceiver._clearReceiverPoll(receiverId);
          return typeof callback === "function" ? callback(status, body) : void 0;
        } else if (status >= 400 && status < 500) {
          bitcoinReceiver._clearReceiverPoll(receiverId);
          return typeof callback === "function" ? callback(status, body) : void 0;
        } else {
          pollInterval = status === 500 ? 5000 : bitcoinReceiver._pollInterval;
          timeoutId = setTimeout(function() {
            return bitcoinReceiver._pollReceiver(receiverId, callback);
          }, pollInterval);
          return bitcoinReceiver._activeReceiverPolls[receiverId]['timeoutId'] = timeoutId;
        }
      });
    };

    bitcoinReceiver.cancelReceiverPoll = function(receiverId) {
      var activeReceiver;
      activeReceiver = bitcoinReceiver._activeReceiverPolls[receiverId];
      if (activeReceiver == null) {
        throw "You are not polling receiver " + receiverId + ".";
      }
      if (activeReceiver['timeoutId'] != null) {
        clearTimeout(activeReceiver['timeoutId']);
      }
      bitcoinReceiver._clearReceiverPoll(receiverId);
    };

    return bitcoinReceiver;

  }).call(this);

  exports = ['createToken', 'getToken', 'cardType', 'validateExpiry', 'validateCVC', 'validateCardNumber'];

  for (_i = 0, _len = exports.length; _i < _len; _i++) {
    key = exports[_i];
    this.Stripe[key] = this.Stripe.card[key];
  }

  if (typeof module !== "undefined" && module !== null) {
    module.exports = this.Stripe;
  }

  if (typeof define === "function") {
    define('stripe', [], function() {
      return _this.Stripe;
    });
  }

}).call(this);
(function() {
  var e, requestID, serialize,
    __slice = [].slice;

  e = encodeURIComponent;

  requestID = new Date().getTime();

  serialize = function(object, result, scope) {
    var key, value;
    if (result == null) {
      result = [];
    }
    for (key in object) {
      value = object[key];
      if (scope) {
        key = "" + scope + "[" + key + "]";
      }
      if (typeof value === 'object') {
        serialize(value, result, key);
      } else {
        result.push("" + key + "=" + (e(value)));
      }
    }
    return result.join('&').replace(/%20/g, '+');
  };

  this.Stripe.ajaxJSONP = function(options) {
    var abort, abortTimeout, callbackName, head, script, xhr;
    if (options == null) {
      options = {};
    }
    callbackName = 'sjsonp' + (++requestID);
    script = document.createElement('script');
    abortTimeout = null;
    abort = function(reason) {
      var _ref;
      if (reason == null) {
        reason = 'abort';
      }
      clearTimeout(abortTimeout);
      if ((_ref = script.parentNode) != null) {
        _ref.removeChild(script);
      }
      if (callbackName in window) {
        window[callbackName] = (function() {});
      }
      return typeof options.complete === "function" ? options.complete(reason, xhr, options) : void 0;
    };
    xhr = {
      abort: abort
    };
    script.onerror = function() {
      xhr.abort();
      return typeof options.error === "function" ? options.error(xhr, options) : void 0;
    };
    window[callbackName] = function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      clearTimeout(abortTimeout);
      script.parentNode.removeChild(script);
      try {
        delete window[callbackName];
      } catch (e) {
        window[callbackName] = void 0;
      }
      if (typeof options.success === "function") {
        options.success.apply(options, args);
      }
      return typeof options.complete === "function" ? options.complete('success', xhr, options) : void 0;
    };
    options.data || (options.data = {});
    options.data.callback = callbackName;
    if (options.method) {
      options.data._method = options.method;
    }
    script.src = options.url + '?' + serialize(options.data);
    head = document.getElementsByTagName('head')[0];
    head.appendChild(script);
    if (options.timeout > 0) {
      abortTimeout = setTimeout(function() {
        return xhr.abort('timeout');
      }, options.timeout);
    }
    return xhr;
  };

}).call(this);
(function() {
  var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  this.Stripe.utils = (function() {

    function utils() {}

    utils.trim = function(str) {
      return (str + '').replace(/^\s+|\s+$/g, '');
    };

    utils.underscore = function(str) {
      return (str + '').replace(/([A-Z])/g, function($1) {
        return "_" + ($1.toLowerCase());
      }).replace(/-/g, '_');
    };

    utils.underscoreKeys = function(data) {
      var key, value, _results;
      _results = [];
      for (key in data) {
        value = data[key];
        delete data[key];
        _results.push(data[this.underscore(key)] = value);
      }
      return _results;
    };

    utils.isElement = function(el) {
      if (typeof el !== 'object') {
        return false;
      }
      if ((typeof jQuery !== "undefined" && jQuery !== null) && el instanceof jQuery) {
        return true;
      }
      return el.nodeType === 1;
    };

    utils.paramsFromForm = function(form, whitelist) {
      var attr, input, inputs, select, selects, values, _i, _j, _len, _len1;
      if (whitelist == null) {
        whitelist = [];
      }
      if ((typeof jQuery !== "undefined" && jQuery !== null) && form instanceof jQuery) {
        form = form[0];
      }
      inputs = form.getElementsByTagName('input');
      selects = form.getElementsByTagName('select');
      values = {};
      for (_i = 0, _len = inputs.length; _i < _len; _i++) {
        input = inputs[_i];
        attr = this.underscore(input.getAttribute('data-stripe'));
        if (__indexOf.call(whitelist, attr) < 0) {
          continue;
        }
        values[attr] = input.value;
      }
      for (_j = 0, _len1 = selects.length; _j < _len1; _j++) {
        select = selects[_j];
        attr = this.underscore(select.getAttribute('data-stripe'));
        if (__indexOf.call(whitelist, attr) < 0) {
          continue;
        }
        if (select.selectedIndex != null) {
          values[attr] = select.options[select.selectedIndex].value;
        }
      }
      return values;
    };

    utils.validateKey = function(key) {
      if (!key || typeof key !== 'string') {
        throw new Error('You did not set a valid publishable key. ' + 'Call Stripe.setPublishableKey() with your publishable key. ' + 'For more info, see https://stripe.com/docs/stripe.js');
      }
      if (/\s/g.test(key)) {
        throw new Error('Your key is invalid, as it contains whitespace. ' + 'For more info, see https://stripe.com/docs/stripe.js');
      }
      if (/^sk_/.test(key)) {
        throw new Error('You are using a secret key with Stripe.js, instead of the publishable one. ' + 'For more info, see https://stripe.com/docs/stripe.js');
      }
    };

    return utils;

  })();

}).call(this);
(function() {
  var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  this.Stripe.validator = {
    boolean: function(expected, value) {
      if (!(value === 'true' || value === 'false')) {
        return "Enter a boolean string (true or false)";
      }
    },
    integer: function(expected, value) {
      if (!/^\d+$/.test(value)) {
        return "Enter an integer";
      }
    },
    positive: function(expected, value) {
      if (!(!this.integer(expected, value) && parseInt(value, 10) > 0)) {
        return "Enter a positive value";
      }
    },
    range: function(expected, value) {
      var _ref;
      if (_ref = parseInt(value, 10), __indexOf.call(expected, _ref) < 0) {
        return "Needs to be between " + expected[0] + " and " + expected[expected.length - 1];
      }
    },
    required: function(expected, value) {
      if (expected && (!(value != null) || value === '')) {
        return "Required";
      }
    },
    year: function(expected, value) {
      if (!/^\d{4}$/.test(value)) {
        return "Enter a 4-digit year";
      }
    },
    birthYear: function(expected, value) {
      var year;
      year = this.year(expected, value);
      if (year) {
        return year;
      } else if (parseInt(value, 10) > 2000) {
        return "You must be over 18";
      } else if (parseInt(value, 10) < 1900) {
        return "Enter your birth year";
      }
    },
    month: function(expected, value) {
      if (this.integer(expected, value)) {
        return "Please enter a month";
      }
      if (this.range([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], value)) {
        return "Needs to be between 1 and 12";
      }
    },
    choices: function(expected, value) {
      if (__indexOf.call(expected, value) < 0) {
        return "Not an acceptable value for this field";
      }
    },
    email: function(expected, value) {
      if (!/^[^@<\s>]+@[^@<\s>]+$/.test(value)) {
        return "That doesn't look like an email address";
      }
    },
    url: function(expected, value) {
      if (!/^https?:\/\/.+\..+/.test(value)) {
        return "Not a valid url";
      }
    },
    usTaxID: function(expected, value) {
      if (!/^\d{2}-?\d{1}-?\d{2}-?\d{4}$/.test(value)) {
        return "Not a valid tax ID";
      }
    },
    ein: function(expected, value) {
      if (!/^\d{2}-?\d{7}$/.test(value)) {
        return "Not a valid EIN";
      }
    },
    ssnLast4: function(expected, value) {
      if (!/^\d{4}$/.test(value)) {
        return "Not a valid last 4 digits for an SSN";
      }
    },
    ownerPersonalID: function(country, value) {
      var match;
      match = (function() {
        switch (country) {
          case 'CA':
            return /^\d{3}-?\d{3}-?\d{3}$/.test(value);
          case 'US':
            return true;
        }
      })();
      if (!match) {
        return "Not a valid ID";
      }
    },
    bizTaxID: function(country, value) {
      var fieldName, match, regex, regexes, validation, validations, _i, _len;
      validations = {
        'CA': ['Tax ID', [/^\d{9}$/]],
        'US': ['EIN', [/^\d{2}-?\d{7}$/]]
      };
      validation = validations[country];
      if (validation != null) {
        fieldName = validation[0];
        regexes = validation[1];
        match = false;
        for (_i = 0, _len = regexes.length; _i < _len; _i++) {
          regex = regexes[_i];
          if (regex.test(value)) {
            match = true;
            break;
          }
        }
        if (!match) {
          return "Not a valid " + fieldName;
        }
      }
    },
    zip: function(country, value) {
      var match;
      match = (function() {
        switch (country.toUpperCase()) {
          case 'CA':
            return /^[\d\w]{6}$/.test(value != null ? value.replace(/\s+/g, '') : void 0);
          case 'US':
            return /^\d{5}$/.test(value) || /^\d{9}$/.test(value);
        }
      })();
      if (!match) {
        return "Not a valid zip";
      }
    },
    bankAccountNumber: function(expected, value) {
      if (!/^\d{1,17}$/.test(value)) {
        return "Invalid bank account number";
      }
    },
    usRoutingNumber: function(value) {
      var index, part1, part2, part3, total, _i, _ref;
      if (!/^\d{9}$/.test(value)) {
        return "Routing number must have 9 digits";
      }
      total = 0;
      for (index = _i = 0, _ref = value.length - 1; _i <= _ref; index = _i += 3) {
        part1 = parseInt(value.charAt(index), 10) * 3;
        part2 = parseInt(value.charAt(index + 1), 10) * 7;
        part3 = parseInt(value.charAt(index + 2), 10);
        total += part1 + part2 + part3;
      }
      if (!(total !== 0 && total % 10 === 0)) {
        return "Invalid routing number";
      }
    },
    caRoutingNumber: function(value) {
      if (!/^\d{5}\-\d{3}$/.test(value)) {
        return "Invalid transit number";
      }
    },
    routingNumber: function(country, value) {
      switch (country.toUpperCase()) {
        case 'CA':
          return this.caRoutingNumber(value);
        case 'US':
          return this.usRoutingNumber(value);
      }
    },
    phoneNumber: function(expected, value) {
      var number;
      number = value.replace(/[^0-9]/g, '');
      if (number.length !== 10) {
        return "Invalid phone number";
      }
    },
    bizDBA: function(expected, value) {
      if (!/^.{1,23}$/.test(value)) {
        return "Statement descriptors can only have up to 23 characters";
      }
    },
    nameLength: function(expected, value) {
      if (value.length === 1) {
        return 'Names need to be longer than one character';
      }
    }
  };

}).call(this);
