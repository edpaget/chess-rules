# frozen_string_literal: true

require "securerandom"

module Chess
  module Ecs
    class Entity
      extend Buildable

      attr_reader :id, :tag, :components

      def initialize(tag, components)
        @id = SecureRandom.uuid

        @tag = tag
        @components = components
      end
    end
  end
end
