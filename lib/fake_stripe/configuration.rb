module FakeStripe
  module Configuration
    attr_writer :fixture_paths

    DEFAULT_FIXTURE_PATH = File.join(File.dirname(__FILE__), 'fixtures/')

    def fixture_path=(new_path)
      @fixture_paths = [new_path]
    end

    def fixture_paths
      @fixture_paths || [DEFAULT_FIXTURE_PATH]
    end

    def fixure_mapping
      @fixture_mapping ||= Hash.new { |hash, key| hash[key] = key }
    end

    def fixture_override(old_fixture_key, new_fixture)
      fixure_mapping[old_fixture_key] = new_fixture
    end

    def configure
      yield self
    end
  end
end
