# frozen_string_literal: true

RSpec.describe TypeEvalRb::ComparisonTree do
  let(:type_matching) { TypeHelper.type_node(TypeHelper.string, TypeHelper.string) }
  let(:type_mismatching) { TypeHelper.type_node(TypeHelper.string, TypeHelper.integer) }

  let(:class_nodes) do
    [
      TypeHelper.class_node(
        typename: RBS::Namespace.parse('::Foo').to_type_name,
        instance_variable_nodes: [],
        method_nodes: [
          TypeHelper.method_node(name: :bar, parameters: [], return_type: type_matching),
          TypeHelper.method_node(name: :baz, parameters: [], return_type: type_mismatching)
        ]
      )
    ]
  end

  let(:tree) { described_class.new(class_nodes:) }

  describe '#count_leaf' do
    it 'sums all class_nodes leaf counts' do
      expect(tree.count_leaf).to eq(class_nodes.sum(&:count_leaf))
    end
  end

  describe '#count_matches' do
    it 'sums all class_nodes match counts' do
      expect(tree.count_matches).to eq(class_nodes.sum(&:count_matches))
    end
  end

  describe '#accuracy' do
    it 'returns count_matches / count_leaf as Float' do
      expect(tree.accuracy).to eq(tree.count_matches.to_f / tree.count_leaf)
    end

    context 'when count_leaf is 0' do
      let(:class_nodes) { [] }

      it 'returns 0.0' do
        expect(tree.accuracy).to eq(0.0)
      end
    end
  end
end
