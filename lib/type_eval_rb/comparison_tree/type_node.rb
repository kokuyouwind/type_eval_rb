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
        return true if top?(expected) || bottom?(actual)
        return false if actual.nil?

        compare_types(expected, actual)
      end

      private

      def untyped?(type)
        type.is_a?(RBS::Types::Bases::Any)
      end

      def top?(type)
        type.is_a?(RBS::Types::Bases::Top)
      end

      def bottom?(type)
        type.is_a?(RBS::Types::Bases::Bottom)
      end

      def compare_types(expected, actual) # rubocop:disable Metrics/CyclomaticComplexity,Metrics/MethodLength
        case expected
        when RBS::Types::ClassInstance
          actual.is_a?(RBS::Types::ClassInstance) && expected.name == actual.name
        when RBS::Types::Bases::Nil
          actual.is_a?(RBS::Types::Bases::Nil)
        when RBS::Types::Block
          actual.is_a?(RBS::Types::Block) && expected.type == actual.type
        when RBS::Types::Union
          compare_union(expected, actual)
        when RBS::Types::Optional
          actual.is_a?(RBS::Types::Optional) &&
            TypeNode.new(expected: expected.type, actual: actual.type).matches?
        when RBS::Types::Tuple
          compare_tuple(expected, actual)
        when RBS::Types::Intersection
          compare_intersection(expected, actual)
        else
          expected == actual
        end
      end

      def compare_union(expected, actual)
        return false unless actual.is_a?(RBS::Types::Union)
        return false unless expected.types.size == actual.types.size

        expected.types.all? do |exp_t|
          actual.types.any? { |act_t| TypeNode.new(expected: exp_t, actual: act_t).matches? }
        end
      end

      def compare_tuple(expected, actual)
        return false unless actual.is_a?(RBS::Types::Tuple)
        return false unless expected.types.size == actual.types.size

        expected.types.zip(actual.types).all? do |exp_t, act_t|
          TypeNode.new(expected: exp_t, actual: act_t).matches?
        end
      end

      def compare_intersection(expected, actual)
        return false unless actual.is_a?(RBS::Types::Intersection)

        expected.types.all? do |exp_t|
          actual.types.any? { |act_t| TypeNode.new(expected: exp_t, actual: act_t).matches? }
        end
      end

      def type_to_string(type) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
        case type
        when RBS::Types::ClassInstance
          type.name.to_s
        when RBS::Types::Bases::Nil
          'nil'
        when RBS::Types::Bases::Any
          'untyped'
        when RBS::Types::Bases::Bool
          'bool'
        when RBS::Types::Bases::Void
          'void'
        when RBS::Types::Bases::Self
          'self'
        when RBS::Types::Bases::Top
          'top'
        when RBS::Types::Bases::Bottom
          'bot'
        when RBS::Types::Union
          type.types.map { |t| type_to_string(t) }.join(' | ')
        when RBS::Types::Optional
          "#{type_to_string(type.type)}?"
        when RBS::Types::Tuple
          "[#{type.types.map { |t| type_to_string(t) }.join(', ')}]"
        when RBS::Types::Intersection
          type.types.map { |t| type_to_string(t) }.join(' & ')
        when RBS::Types::Block
          params = type.type.required_positionals.map { |p| type_to_string(p.type) }.join(', ')
          "{ (#{params}) -> #{type_to_string(type.type.return_type)} }"
        else
          type.to_s
        end
      end
    end
  end
end
