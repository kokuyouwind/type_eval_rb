# frozen_string_literal: true

RSpec.describe TypeEvalRb::ComparisonTree::TypeNode do
  let(:type_node) { described_class.new(expected: TypeHelper.string, actual: TypeHelper.undefined) }

  describe '#initialize' do
    subject { type_node }

    it 'sets the expected type and actual type' do
      expect(subject.expected).to eq(TypeHelper.string)
      expect(subject.actual).to eq(TypeHelper.undefined)
    end
  end

  describe '#pretty_print' do
    let(:node) { type_node }

    it_behaves_like 'output expected pretty_print', <<~EXPECTED.strip
      TypeNode( expected="::String", actual="untyped")
    EXPECTED
  end
end
