module TypeEvalRb
  class Comparator
    def initialize(expected_env, actual_env)
      @expected_env = expected_env
      @actual_env = actual_env
    end

    def compare(class_name)
      expected_decl = @expected_env.class_decls[RBS::TypeName.new(name: class_name.to_sym, namespace: RBS::Namespace.root)]
      actual_decl = @actual_env.class_decls[RBS::TypeName.new(name: class_name.to_sym, namespace: RBS::Namespace.root)]
      compare_class_decl(expected_decl, actual_decl)
    end

    private

    def compare_class_decl(expected_decl, actual_decl)
      Comparison::ClassNode.new(
        name: expected_decl.name.name.to_s,
        instance_variables: compare_instance_variables(expected_decl, actual_decl),
        methods: compare_methods(expected_decl, actual_decl)
      )
    end

    def compare_instance_variables(expected_decl, actual_decl)
      expected_decl.decls.first.decl.members.select { |member| member.is_a?(RBS::AST::Members::InstanceVariable) }.map do |expected_ivar|
        actual_ivar = actual_decl.decls.first.decl.members.find { |member| member.is_a?(RBS::AST::Members::InstanceVariable) && member.name == expected_ivar.name }
        Comparison::InstanceVariableNode.new(
          name: expected_ivar.name.to_s,
          expected_type: type_to_string(expected_ivar.type),
          actual_type: actual_ivar ? type_to_string(actual_ivar.type) : 'missing'
        )
      end
    end

    def compare_methods(expected_decl, actual_decl)
      expected_decl.decls.first.decl.members.select { |member| member.is_a?(RBS::AST::Members::MethodDefinition) }.map do |expected_method|
        actual_method = actual_decl.decls.first.decl.members.find { |member| member.is_a?(RBS::AST::Members::MethodDefinition) && member.name == expected_method.name }
        Comparison::MethodNode.new(
          name: expected_method.name.to_s,
          parameters: compare_method_parameters(expected_method, actual_method),
          return_type: Comparison::TypeNode.new(
            expected: type_to_string(expected_method.overloads.first.method_type.type.return_type),
            actual: actual_method ? type_to_string(actual_method.overloads.first.method_type.type.return_type) : 'missing'
          )
        )
      end
    end

    def compare_method_parameters(expected_method, actual_method)
      expected_method.overloads.first.method_type.type.required_positionals.map.with_index do |expected_param, index|
        actual_param = actual_method&.overloads&.first&.method_type&.type&.required_positionals[index]
        Comparison::ArgumentNode.new(
          name: expected_param.name.to_s,
          type: Comparison::TypeNode.new(
            expected: type_to_string(expected_param.type),
            actual: actual_param ? type_to_string(actual_param.type) : 'missing'
          )
        )
      end
    end

    def type_to_string(type)
      case type
        when RBS::Types::ClassInstance
          type.name.name.to_s
        when RBS::Types::Bases::Any
          'untyped'
        else
          type.to_s
      end
    end
  end

  module Comparison
    class Node
      attr_reader :children

      def initialize(children = [])
        @children = children
      end

      def count_leaf
        children.sum(0) do |child|
          child.is_a?(self.class) ? child.count_leaf : 1
        end
      end

      def count_matches
        children.sum(0) do |child|
          child.is_a?(self.class) ? child.count_matches : (yield(child) ? 1 : 0)
        end
      end

      def inspect
        raise NotImplementedError, "Subclasses must implement the 'to_s' method."
      end
    end

    class ClassNode < Node
      attr_reader :name, :instance_variables, :methods

      def initialize(name:, instance_variables:, methods:)
        @name = name
        @instance_variables = instance_variables
        @methods = methods
        super(instance_variables + methods)
      end

      def inspect
        "ClassNode(name=#{name}, instance_variables=#{instance_variables}, methods=#{methods})"
      end
    end

    class MethodNode < Node
      attr_reader :name, :parameters, :return_type

      def initialize(name:, parameters:, return_type:)
        @name = name
        @parameters = parameters
        @return_type = return_type
        super(parameters + [return_type])
      end

      def inspect
        "MethodNode(name=#{name}, parameters=#{parameters}, return_type=#{return_type})"
      end
    end

    class InstanceVariableNode < Node
      attr_reader :name, :expected_type, :actual_type

      def initialize(name:, expected_type:, actual_type:)
        @name = name
        @expected_type = expected_type
        @actual_type = actual_type
        super()
      end

      def inspect
        "InstanceVariableNode(name=#{name}, expected_type=#{expected_type}, actual_type=#{actual_type})"
      end
    end

    class ArgumentNode < Node
      attr_reader :name, :type

      def initialize(name:, type:)
        @name = name
        @type = type
        super([type])
      end

      def inspect
        "ArgumentNode(name=#{name}, type=#{type})"
      end
    end

    class TypeNode < Node
      attr_reader :expected, :actual

      def initialize(expected:, actual:)
        @expected = expected
        @actual = actual
        super()
      end

      def inspect
        "TypeNode(expected=#{expected}, actual=#{actual})"
      end
    end
  end
end
