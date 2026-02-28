# frozen_string_literal: true

RSpec.describe TypeEvalRb::ComparisonTree::ClassNode do
  let(:typename) { RBS::Namespace.parse('::Hoge::Fuga').to_type_name }
  let(:instance_variable_nodes) do
    [
      TypeHelper.instance_variable_node(
        name: :@name,
        type: TypeHelper.type_node(TypeHelper.string, TypeHelper.undefined)
      )
    ]
  end
  let(:method_nodes) do
    [
      TypeHelper.method_node(
        name: :to_s,
        parameters: [],
        return_type: TypeHelper.type_node(TypeHelper.string, TypeHelper.undefined)
      )
    ]
  end
  let(:class_node) { described_class.new(typename:, instance_variable_nodes:, method_nodes:) }

  describe '#initialize' do
    subject { class_node }

    it 'sets the typename, instance_variables, and methods' do
      expect(subject.typename).to eq(typename)
      expect(subject.instance_variable_nodes).to eq(instance_variable_nodes)
      expect(subject.method_nodes).to eq(method_nodes)
    end
  end

  describe '#count_leaf' do
    it 'sums instance_variables and methods leaf counts' do
      expected = instance_variable_nodes.sum(&:count_leaf) + method_nodes.sum(&:count_leaf)
      expect(class_node.count_leaf).to eq(expected)
    end
  end

  describe '#count_matches' do
    it 'sums instance_variables and methods match counts' do
      expected = instance_variable_nodes.sum(&:count_matches) + method_nodes.sum(&:count_matches)
      expect(class_node.count_matches).to eq(expected)
    end
  end

  describe '#pretty_print' do
    let(:node) { class_node }

    it_behaves_like 'output expected pretty_print', <<~EXPECTED.strip
      ClassNode(typename=::Hoge::Fuga,#{' '}
        instance_variables=[
          InstanceVariableNode(name=@name,
            type=TypeNode( expected="::String", actual="untyped")
            )
      #{'    '}
        ],
        methods=[
          MethodNode(name=to_s,#{' '}
            parameters=[#{' '}
            ],
            return_type=TypeNode( expected="::String", actual="untyped"))
          ])
    EXPECTED
  end
end
