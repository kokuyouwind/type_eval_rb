# frozen_string_literal: true

module TypeEvalRb
  class ComparisonTree
    class TypeNode < Node
      attr_reader :expected, :actual

      def initialize(expected:, actual:)
        @expected = expected
        @actual = actual
        super()
      end

      def pretty_print(q) # rubocop:disable Naming/MethodParameterName
        q.group(2, 'TypeNode(') do
          q.breakable
          q.text('expected=')
          q.pp(type_to_string(expected))
          q.text(',')
          q.breakable
          q.text('actual=')
          q.pp(type_to_string(actual))
          q.text(')')
        end
      end

      private

      def type_to_string(type)
        case type
        when RBS::Types::ClassInstance
          type.name.to_s
        else
          type.to_s
        end
      end
    end
  end
end
