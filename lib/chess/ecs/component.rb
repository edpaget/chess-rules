# frozen_string_literal: true

require "chess/ecs/buildable"

module Chess
  module Ecs
    class Component
      extend Buildable

      attr_reader :tag, :data

      delegate :hash, to: :tag

      def initialize(tag, data)
        @tag = tag
        @data = data
      end

      def deconstruct_keys(_)
        { tag: tag, data: data }
      end
    end
  end
end
