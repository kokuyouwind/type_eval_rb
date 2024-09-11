# frozen_string_literal: true

module TypeEvalRb
  class ComparisonTree
    class ArgumentNode < Node
      attr_reader :name, :type

      def initialize(name:, type:)
        @name = name
        @type = type
        super()
      end

      def pretty_print(q) # rubocop:disable Naming/MethodParameterName
        q.group(2, "ArgumentNode(name=#{name}, ") do
          q.breakable
          q.text('type=')
          q.pp(type)
          q.text(')')
        end
      end
    end
  end
end
