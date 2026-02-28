# frozen_string_literal: true

RSpec.describe TypeEvalRb::ComparisonTree::ArgumentNode do
  let(:name) { :foo }
  let(:type) { TypeHelper.type_node(TypeHelper.string, TypeHelper.undefined) }
  let(:argument_node) { described_class.new(name:, type:) }

  describe '#initialize' do
    subject { argument_node }

    it 'sets the name and type' do
      expect(subject.name).to eq(name)
      expect(subject.type).to eq(type)
    end

    it 'defaults required to true' do
      expect(subject.required).to be true
    end

    it 'defaults param_type to :positional' do
      expect(subject.param_type).to eq(:positional)
    end

    it 'defaults rest to false' do
      expect(subject.rest).to be false
    end

    context 'when required: false' do
      let(:argument_node) { described_class.new(name:, type:, required: false) }

      it 'sets required to false' do
        expect(subject.required).to be false
      end
    end

    context 'when param_type: :keyword' do
      let(:argument_node) { described_class.new(name:, type:, param_type: :keyword) }

      it 'sets param_type to :keyword' do
        expect(subject.param_type).to eq(:keyword)
      end
    end
  end

  describe '#count_leaf' do
    it 'delegates to type.count_leaf' do
      expect(argument_node.count_leaf).to eq(type.count_leaf)
    end
  end

  describe '#count_matches' do
    it 'delegates to type.count_matches' do
      expect(argument_node.count_matches).to eq(type.count_matches)
    end
  end

  describe '#pretty_print' do
    let(:node) { argument_node }

    it_behaves_like 'output expected pretty_print', <<~EXPECTED.strip
      ArgumentNode(name=foo, required=true, param_type=positional, rest=false,#{' '}
        type=TypeNode( expected="::String", actual="untyped"))
    EXPECTED
  end
end
