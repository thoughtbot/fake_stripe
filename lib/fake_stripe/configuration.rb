module FakeStripe
  module Configuration
    attr_writer :fixture_path
    attr_writer :stripe_token

    DEFAULT_FIXTURE_PATH = File.join(File.dirname(__FILE__), 'fixtures/')
    DEFAULT_TOKEN = 'tok_123'

    def fixture_path
      @fixture_path or DEFAULT_FIXTURE_PATH
    end

    def stripe_token
      @stripe_token || DEFAULT_TOKEN
    end

    def configure
      yield self
    end
  end
end
