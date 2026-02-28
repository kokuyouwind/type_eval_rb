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

    def integer
      RBS::Types::ClassInstance.new(name: type_name('::Integer'), location: nil, args: [])
    end

    def nil_type
      RBS::Types::Bases::Nil.new(location: nil)
    end

    def bool_type
      RBS::Types::Bases::Bool.new(location: nil)
    end

    def void_type
      RBS::Types::Bases::Void.new(location: nil)
    end

    def self_type
      RBS::Types::Bases::Self.new(location: nil)
    end

    def top_type
      RBS::Types::Bases::Top.new(location: nil)
    end

    def bottom_type
      RBS::Types::Bases::Bottom.new(location: nil)
    end

    def union_type(*types)
      RBS::Types::Union.new(types:, location: nil)
    end

    def optional_type(type)
      RBS::Types::Optional.new(type:, location: nil)
    end

    def tuple_type(*types)
      RBS::Types::Tuple.new(types:, location: nil)
    end

    def intersection_type(*types)
      RBS::Types::Intersection.new(types:, location: nil)
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

    def class_node(typename:, instance_variable_nodes:, method_nodes:)
      TypeEvalRb::ComparisonTree::ClassNode.new(typename:, instance_variable_nodes:, method_nodes:)
    end
  end
end
