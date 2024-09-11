# frozen_string_literal: true

require_relative 'comparison_tree/node'

require_relative 'comparison_tree/argument_node'
require_relative 'comparison_tree/class_node'
require_relative 'comparison_tree/method_node'
require_relative 'comparison_tree/instance_variable_node'
require_relative 'comparison_tree/type_node'

module TypeEvalRb
  class ComparisonTree
    attr_reader :class_nodes, :expected, :actual

    class << self
      def from_envs(expected:, actual:)
        class_decls_keys = expected.class_decls.keys | actual.class_decls.keys
        class_nodes = class_decls_keys.map do |typename|
          ComparisonTree::ClassNode.from_decls(
            typename,
            expected.class_decls[typename].decls.first.decl,
            actual.class_decls[typename].decls.first.decl
          )
        end

        new(class_nodes:, expected:, actual:)
      end
    end

    def initialize(class_nodes:, expected: nil, actual: nil)
      @class_nodes = class_nodes
      @expected = expected
      @actual = actual
    end

    def inspect
      "ComparisonTree(class_nodes=#{class_nodes.inspect})"
    end

    def pretty_print(q) # rubocop:disable Naming/MethodParameterName
      q.group(2, 'ComparisonTree(') do
        q.breakable
        q.group(2, 'class_nodes=[') do
          q.breakable
          class_nodes.each do |class_node|
            q.pp(class_node)
            q.breakable
          end
        end
        q.text(']')
        q.text(')')
      end
    end
  end
end
