# frozen_string_literal: true

module TypeEvalRb
  class ComparisonTree
    class InstanceVariableNode < Node
      attr_reader :name, :type, :expected, :actual

      class << self
        def from_ast(name, expected, actual)
          new(
            name:,
            type: TypeNode.new(expected: expected.type, actual: actual.type),
            expected:,
            actual:
          )
        end
      end

      def initialize(name:, type:, expected: nil, actual: nil)
        @name = name
        @type = type
        @expected = expected
        @actual = actual
        super()
      end

      def pretty_print(q) # rubocop:disable Naming/MethodParameterName
        q.group(2, "InstanceVariableNode(name=#{name},") do
          q.breakable
          q.text('type=')
          q.pp(type)
          q.breakable
          q.text(')')
        end
      end
    end
  end
end
