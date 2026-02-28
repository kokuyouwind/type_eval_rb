# frozen_string_literal: true

module TypeEvalRb
  class ComparisonTree
    class ArgumentNode < Node
      attr_reader :name, :type, :required

      def initialize(name:, type:, required: true)
        @name = name
        @type = type
        @required = required
        super()
      end

      def count_leaf
        @type.count_leaf
      end

      def count_matches
        @type.count_matches
      end

      def pretty_print(q) # rubocop:disable Naming/MethodParameterName
        q.group(2, "ArgumentNode(name=#{name}, required=#{required}, ") do
          q.breakable
          q.text('type=')
          q.pp(type)
          q.text(')')
        end
      end
    end
  end
end
