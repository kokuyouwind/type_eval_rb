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

  describe '#matches?' do
    context 'when expected and actual are identical ClassInstance types' do
      let(:type_node) { described_class.new(expected: TypeHelper.string, actual: TypeHelper.string) }

      it 'returns true' do
        expect(type_node.matches?).to be true
      end
    end

    context 'when actual is untyped' do
      let(:type_node) { described_class.new(expected: TypeHelper.string, actual: TypeHelper.undefined) }

      it 'returns true' do
        expect(type_node.matches?).to be true
      end
    end

    context 'when expected is untyped' do
      let(:type_node) { described_class.new(expected: TypeHelper.undefined, actual: TypeHelper.string) }

      it 'returns true' do
        expect(type_node.matches?).to be true
      end
    end

    context 'when expected is nil type and actual is nil type' do
      let(:type_node) { described_class.new(expected: TypeHelper.nil_type, actual: TypeHelper.nil_type) }

      it 'returns true' do
        expect(type_node.matches?).to be true
      end
    end

    context 'when expected and actual are different ClassInstance types' do
      let(:type_node) { described_class.new(expected: TypeHelper.string, actual: TypeHelper.integer) }

      it 'returns false' do
        expect(type_node.matches?).to be false
      end
    end

    context 'when actual is nil' do
      let(:type_node) { described_class.new(expected: TypeHelper.string, actual: nil) }

      it 'returns false' do
        expect(type_node.matches?).to be false
      end
    end
  end

  describe '#matches? with composite types' do
    context 'with identical union types' do
      let(:type_node) do
        described_class.new(
          expected: TypeHelper.union_type(TypeHelper.string, TypeHelper.integer),
          actual: TypeHelper.union_type(TypeHelper.string, TypeHelper.integer)
        )
      end

      it 'returns true' do
        expect(type_node.matches?).to be true
      end
    end

    context 'with union types in different order' do
      let(:type_node) do
        described_class.new(
          expected: TypeHelper.union_type(TypeHelper.string, TypeHelper.integer),
          actual: TypeHelper.union_type(TypeHelper.integer, TypeHelper.string)
        )
      end

      it 'returns true' do
        expect(type_node.matches?).to be true
      end
    end

    context 'with mismatched union types' do
      let(:type_node) do
        described_class.new(
          expected: TypeHelper.union_type(TypeHelper.string, TypeHelper.integer),
          actual: TypeHelper.union_type(TypeHelper.string, TypeHelper.nil_type)
        )
      end

      it 'returns false' do
        expect(type_node.matches?).to be false
      end
    end

    context 'with identical optional types' do
      let(:type_node) do
        described_class.new(
          expected: TypeHelper.optional_type(TypeHelper.string),
          actual: TypeHelper.optional_type(TypeHelper.string)
        )
      end

      it 'returns true' do
        expect(type_node.matches?).to be true
      end
    end

    context 'with mismatched optional types' do
      let(:type_node) do
        described_class.new(
          expected: TypeHelper.optional_type(TypeHelper.string),
          actual: TypeHelper.optional_type(TypeHelper.integer)
        )
      end

      it 'returns false' do
        expect(type_node.matches?).to be false
      end
    end

    context 'with identical tuple types' do
      let(:type_node) do
        described_class.new(
          expected: TypeHelper.tuple_type(TypeHelper.string, TypeHelper.integer),
          actual: TypeHelper.tuple_type(TypeHelper.string, TypeHelper.integer)
        )
      end

      it 'returns true' do
        expect(type_node.matches?).to be true
      end
    end

    context 'with different-length tuple types' do
      let(:type_node) do
        described_class.new(
          expected: TypeHelper.tuple_type(TypeHelper.string, TypeHelper.integer),
          actual: TypeHelper.tuple_type(TypeHelper.string)
        )
      end

      it 'returns false' do
        expect(type_node.matches?).to be false
      end
    end

    context 'with identical intersection types' do
      let(:type_node) do
        described_class.new(
          expected: TypeHelper.intersection_type(TypeHelper.string, TypeHelper.integer),
          actual: TypeHelper.intersection_type(TypeHelper.string, TypeHelper.integer)
        )
      end

      it 'returns true' do
        expect(type_node.matches?).to be true
      end
    end

    context 'with bool type' do
      let(:type_node) do
        described_class.new(expected: TypeHelper.bool_type, actual: TypeHelper.bool_type)
      end

      it 'returns true' do
        expect(type_node.matches?).to be true
      end
    end

    context 'with void type' do
      let(:type_node) do
        described_class.new(expected: TypeHelper.void_type, actual: TypeHelper.void_type)
      end

      it 'returns true' do
        expect(type_node.matches?).to be true
      end
    end

    context 'with self type' do
      let(:type_node) do
        described_class.new(expected: TypeHelper.self_type, actual: TypeHelper.self_type)
      end

      it 'returns true' do
        expect(type_node.matches?).to be true
      end
    end

    context 'with top type' do
      let(:type_node) do
        described_class.new(expected: TypeHelper.top_type, actual: TypeHelper.string)
      end

      it 'returns true (top matches everything)' do
        expect(type_node.matches?).to be true
      end
    end

    context 'with bottom type' do
      let(:type_node) do
        described_class.new(expected: TypeHelper.string, actual: TypeHelper.bottom_type)
      end

      it 'returns true (bottom is subtype of all)' do
        expect(type_node.matches?).to be true
      end
    end
  end

  describe '#count_leaf' do
    it 'returns 1' do
      expect(type_node.count_leaf).to eq(1)
    end
  end

  describe '#count_matches' do
    context 'when types match' do
      let(:type_node) { described_class.new(expected: TypeHelper.string, actual: TypeHelper.string) }

      it 'returns 1' do
        expect(type_node.count_matches).to eq(1)
      end
    end

    context 'when types do not match' do
      let(:type_node) { described_class.new(expected: TypeHelper.string, actual: TypeHelper.integer) }

      it 'returns 0' do
        expect(type_node.count_matches).to eq(0)
      end
    end
  end

  describe '#pretty_print' do
    let(:node) { type_node }

    it_behaves_like 'output expected pretty_print', <<~EXPECTED.strip
      TypeNode( expected="::String", actual="untyped")
    EXPECTED
  end
end
