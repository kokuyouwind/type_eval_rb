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

      def count_leaf
        1
      end

      def count_matches
        matches? ? 1 : 0
      end

      def matches?
        return true if untyped?(expected) || untyped?(actual)
        return false if actual.nil?

        compare_types(expected, actual)
      end

      private

      def untyped?(type)
        type.is_a?(RBS::Types::Bases::Any)
      end

      def compare_types(expected, actual)
        case expected
        when RBS::Types::ClassInstance
          actual.is_a?(RBS::Types::ClassInstance) && expected.name == actual.name
        when RBS::Types::Bases::Nil
          actual.is_a?(RBS::Types::Bases::Nil)
        else
          expected == actual
        end
      end

      def type_to_string(type)
        case type
        when RBS::Types::ClassInstance
          type.name.to_s
        when RBS::Types::Bases::Nil
          'nil'
        when RBS::Types::Bases::Any
          'untyped'
        else
          type.to_s
        end
      end
    end
  end
end
