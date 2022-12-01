# frozen_string_literal: true

module Chess
  module Ecs
    class EntityTable
      def initialize
        @table = Hash.new { |h, k| h[k] = [] }
      end

      def add_entity(entity)
        @table[entity.id] << entity
        
        entity.components.each do |comp|
          @table[comp] << entity
        end
      end
    end
  end
end
