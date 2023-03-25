module FakeStripe
  module Configuration
    attr_writer :fixture_path
    attr_writer :js_v3_token
    attr_writer :api_key
    attr_writer :stripe_account
    attr_writer :api_host

    DEFAULT_FIXTURE_PATH = File.join(File.dirname(__FILE__), 'fixtures/')
    DEFAULT_TOKEN = "tok_123".freeze
    DEFAULT_API_KEY = "sk_1234"
    DEFAULT_STRIPE_ACCOUNT = "acct_123"
    DEFAULT_API_HOST = "api.stripe.com"

    def fixture_path
      @fixture_path or DEFAULT_FIXTURE_PATH
    end

    def js_v3_token
      @js_v3_token || DEFAULT_TOKEN
    end

    def api_key
      @api_key || DEFAULT_API_KEY
    end

    def stripe_account
      @stripe_account || DEFAULT_STRIPE_ACCOUNT
    end

    def api_host
      @api_host || DEFFAULT_API_HOST
    end

    def configure
      yield self
    end
  end
end
