# frozen_string_literal: true

RSpec.describe TypeEvalRb::ComparisonTree::InstanceVariableNode do
  let(:name) { :@foo }
  let(:type) { TypeHelper.type_node(TypeHelper.string, TypeHelper.undefined) }
  let(:instance_variable_node) { described_class.new(name:, type:) }

  describe '#initialize' do
    subject { instance_variable_node }

    it 'sets the name and type' do
      expect(subject.name).to eq(name)
      expect(subject.type).to eq(type)
    end
  end

  describe '#pretty_print' do
    let(:node) { instance_variable_node }

    it_behaves_like 'output expected pretty_print', <<~EXPECTED.strip
      InstanceVariableNode(name=@foo,
        type=TypeNode( expected="::String", actual="untyped")
        )
    EXPECTED
  end
end
