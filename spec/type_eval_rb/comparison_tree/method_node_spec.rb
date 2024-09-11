# frozen_string_literal: true

RSpec.describe TypeEvalRb::ComparisonTree::MethodNode do
  let(:name) { :foo }
  let(:parameters) do
    [TypeHelper.argument_node(
      :bar,
      TypeHelper.type_node(TypeHelper.string, TypeHelper.undefined)
    )]
  end
  let(:return_type) { TypeHelper.type_node(TypeHelper.string, TypeHelper.undefined) }
  let(:method_node) { described_class.new(name:, parameters:, return_type:) }

  describe '#initialize' do
    subject { method_node }

    it 'sets the name, parameters, and return_type' do
      expect(subject.name).to eq(name)
      expect(subject.parameters).to eq(parameters)
      expect(subject.return_type).to eq(return_type)
    end
  end

  describe '#pretty_print' do
    let(:node) { method_node }

    it_behaves_like 'output expected pretty_print', <<~EXPECTED.strip
      MethodNode(name=foo,#{' '}
        parameters=[
          ArgumentNode(name=bar,#{' '}
            type=TypeNode( expected="::String", actual="untyped"))
      #{'    '}
        ],
        return_type=TypeNode( expected="::String", actual="untyped"))
    EXPECTED
  end
end
