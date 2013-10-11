module FakeStripe
  module Configuration
    attr_writer :fixture_path

    DEFAULT_FIXTURE_PATH = File.join(File.dirname(__FILE__), 'fixtures/')

    def fixture_path
      @fixture_path or DEFAULT_FIXTURE_PATH
    end

    def configure
      yield self
    end
  end
end
