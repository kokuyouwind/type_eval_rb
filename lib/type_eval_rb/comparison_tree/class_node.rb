# frozen_string_literal: true

module TypeEvalRb
  class ComparisonTree
    class ClassNode < Node
      class ClassNameNotMatchedError < StandardError; end
      attr_reader :typename, :instance_variable_nodes, :method_nodes, :expected, :actual

      class << self
        def from_decls(typename, expected, actual)
          new(
            typename:,
            instance_variable_nodes: instance_variables_to_nodes(expected, actual),
            method_nodes: methods_to_nodes(expected, actual),
            expected:,
            actual:
          )
        end

        private

        def instance_variables_to_nodes(expected, actual)
          expected.members.select do |member|
            member.is_a?(RBS::AST::Members::InstanceVariable)
          end.map do |expected_ivar|
            actual_ivar = actual.members.find do |member|
              member.is_a?(RBS::AST::Members::InstanceVariable) && member.name == expected_ivar.name
            end
            InstanceVariableNode.from_ast(expected_ivar.name.to_s, expected_ivar, actual_ivar)
          end
        end

        def methods_to_nodes(expected, actual)
          expected.members.select do |member|
            member.is_a?(RBS::AST::Members::MethodDefinition)
          end.map do |expected_method|
            actual_method = actual.members.find do |member|
              member.is_a?(RBS::AST::Members::MethodDefinition) && member.name == expected_method.name
            end
            MethodNode.from_ast(expected_method.name.to_s, expected_method, actual_method)
          end
        end
      end

      def initialize(typename:, instance_variable_nodes:, method_nodes:, expected: nil, actual: nil)
        @typename = typename
        @instance_variable_nodes = instance_variable_nodes
        @method_nodes = method_nodes
        @expected = expected
        @actual = actual
        super()
      end

      def pretty_print(q) # rubocop:disable Naming/MethodParameterName,Metrics/AbcSize, Metrics/MethodLength
        q.group(2, "ClassNode(typename=#{typename}, ") do
          q.breakable
          q.group(2, 'instance_variables=[') do
            q.breakable
            instance_variable_nodes.each do |ivar|
              q.pp(ivar)
              q.breakable
            end
          end
          q.breakable
          q.text('],')
          q.breakable
          q.group(2, 'methods=[') do
            q.breakable
            method_nodes.each do |method|
              q.pp(method)
              q.breakable
            end
            q.text(']')
          end
          q.text(')')
        end
      end
    end
  end
end
