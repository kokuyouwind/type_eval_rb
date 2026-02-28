# frozen_string_literal: true

module TypeEvalRb
  class ComparisonTree
    class MethodNode < Node
      attr_reader :name, :parameters, :return_type, :expected, :actual

      class << self
        def from_ast(name, expected, actual)
          new(
            name:,
            parameters: parameters_to_nodes(expected, actual),
            return_type: return_types_to_node(expected, actual),
            expected:,
            actual:
          )
        end

        private

        def parameters_to_nodes(expected, actual) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
          method_type = expected.overloads.first.method_type.type
          actual_method_type = actual&.overloads&.first&.method_type&.type

          required = method_type.required_positionals.map.with_index do |param, index|
            actual_param = actual_method_type&.required_positionals&.[](index)
            build_argument_node(param, actual_param, required: true)
          end

          optional = method_type.optional_positionals.map.with_index do |param, index|
            actual_param = actual_method_type&.optional_positionals&.[](index)
            build_argument_node(param, actual_param, required: false)
          end

          req_kw = method_type.required_keywords.map do |kw_name, param|
            actual_param = actual_method_type&.required_keywords&.[](kw_name)
            build_keyword_argument_node(kw_name, param, actual_param, required: true)
          end

          opt_kw = method_type.optional_keywords.map do |kw_name, param|
            actual_param = actual_method_type&.optional_keywords&.[](kw_name)
            build_keyword_argument_node(kw_name, param, actual_param, required: false)
          end

          rest_pos = if method_type.rest_positionals
                       actual_rest = actual_method_type&.rest_positionals
                       [build_argument_node(method_type.rest_positionals, actual_rest, required: false, rest: true)]
                     else
                       []
                     end

          rest_kw = if method_type.rest_keywords
                      actual_rest_kw = actual_method_type&.rest_keywords
                      [build_argument_node(method_type.rest_keywords, actual_rest_kw,
                                           required: false, param_type: :keyword, rest: true)]
                    else
                      []
                    end

          required + optional + rest_pos + req_kw + opt_kw + rest_kw
        end

        def build_argument_node(expected_param, actual_param, required:, param_type: :positional, rest: false)
          ComparisonTree::ArgumentNode.new(
            name: expected_param.name.to_s,
            type: ComparisonTree::TypeNode.new(
              expected: expected_param.type,
              actual: actual_param ? actual_param.type : nil
            ),
            required:,
            param_type:,
            rest:
          )
        end

        def build_keyword_argument_node(kw_name, expected_param, actual_param, required:)
          ComparisonTree::ArgumentNode.new(
            name: kw_name.to_s,
            type: ComparisonTree::TypeNode.new(
              expected: expected_param.type,
              actual: actual_param ? actual_param.type : nil
            ),
            required:,
            param_type: :keyword
          )
        end

        def return_types_to_node(expected, actual)
          ComparisonTree::TypeNode.new(
            expected: expected.overloads.first.method_type.type.return_type,
            actual: actual ? actual.overloads.first.method_type.type.return_type : nil
          )
        end
      end

      def initialize(name:, parameters:, return_type:, expected: nil, actual: nil)
        @name = name
        @parameters = parameters
        @return_type = return_type
        @expected = expected
        @actual = actual
        super()
      end

      def count_leaf
        @parameters.sum(&:count_leaf) + @return_type.count_leaf
      end

      def count_matches
        @parameters.sum(&:count_matches) + @return_type.count_matches
      end

      def pretty_print(q) # rubocop:disable Naming/MethodParameterName,Metrics/MethodLength
        q.group(2, "MethodNode(name=#{name}, ") do
          q.breakable
          q.group(2, 'parameters=[') do
            q.breakable
            parameters.each do |param|
              q.pp(param)
              q.breakable
            end
          end
          q.breakable
          q.text('],')
          q.breakable
          q.text('return_type=')
          q.pp(return_type)
          q.text(')')
        end
      end
    end
  end
end
