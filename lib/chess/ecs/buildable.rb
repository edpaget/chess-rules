# frozen_string_literal: true

module Chess
  module Ecs
    module Buildable
      def new_factory(tag)
        Factory.new(self, tag)
      end
    end
  end
end
