# frozen_string_literal: true

require "spec_helper"

describe Chess::Ecs::Factory do
  subject(:factory) { described_class.new(klass, "test") }

  let(:klass) do
    double(Class)
  end

  before do
    allow(klass).to receive(:new)
  end

  describe "#build" do
    it "initializes a new object" do
      factory.build

      expect(klass).to have_received(:new).with("test", nil)
    end
  end
end
