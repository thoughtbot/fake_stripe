RSpec.shared_examples "a bootable server" do
  describe "#boot_once" do
    it "returns a capybara server" do
      expect(described_class.boot_once).to be_a(Capybara::Server)
    end

    it "returns the same server each invocation" do
      expect(described_class.boot_once).to eq described_class.boot_once
    end
  end

  describe "#server_port" do
    it "returns a port number" do
      expect(described_class.server_port).to be_an(Integer)
    end

    it "returns the same value each invocation" do
      expect(described_class.server_port).to eq described_class.server_port
    end
  end
end
