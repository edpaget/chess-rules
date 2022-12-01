RSpec.shared_examples "a buildable" do
  describe ".new_factory" do
    subject(:factory) { described_class.new_factory(test_tag) }
    
    let(:test_tag) { "test_tag" }

    it "creates a factory with the class" do
      expect(factory.build).to be_a(described_class)
    end

    it "creates a facotry with the tag" do
      expect(factory.build.tag).to eq(test_tag)
    end
  end
end
