# frozen_string_literal: true

module TypeHelper
  class << self
    def type_name(name)
      RBS::Namespace.parse(name).to_type_name
    end

    def undefined
      RBS::Types::Bases::Any.new(location: nil)
    end

    def string
      RBS::Types::ClassInstance.new(name: type_name('::String'), location: nil, args: [])
    end

    def type_node(expected, actual)
      TypeEvalRb::ComparisonTree::TypeNode.new(expected:, actual:)
    end

    def argument_node(name, type)
      TypeEvalRb::ComparisonTree::ArgumentNode.new(name:, type:)
    end

    def method_node(name:, parameters:, return_type:)
      TypeEvalRb::ComparisonTree::MethodNode.new(name:, parameters:, return_type:)
    end

    def instance_variable_node(name:, type:)
      TypeEvalRb::ComparisonTree::InstanceVariableNode.new(name:, type:)
    end
  end
end
