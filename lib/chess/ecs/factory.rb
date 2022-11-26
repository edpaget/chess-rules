# frozen_string_literal: true

module Chess
  module Ecs
    class Factory
      def initialize(klass, tag)
        @klass = klass
        @tag = tag
      end

      def build(data: nil)
        @klass.new(@tag, data)
      end
    end
  end
end
