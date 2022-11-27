# frozen_string_literal: true

require "securerandom"
require "chess/ecs/buildable"

module Chess
  module Ecs
    class Entity
      extend Buildable

      attr_reader :id, :tag, :components

      def initialize(tag, components, id)
        @id = SecureRandom.uuid

        @tag = tag
        @components = components
      end

      def deconstruct_keys(_)
        { id: id, tag: tag, components: components }
      end
    end
  end
end
