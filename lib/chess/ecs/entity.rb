# frozen_string_literal: true

require "securerandom"

module Chess
  module Ecs
    class Entity
      attr_reader :id, :components

      def initialize(components, id: nil)
        @id = id || SecureRandom.uuid

        @components = components
      end

      def deconstruct_keys(_)
        { id: id, tag: tag, components: components }
      end
    end
  end
end
