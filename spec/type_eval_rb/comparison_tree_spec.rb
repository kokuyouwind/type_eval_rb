# frozen_string_literal: true

RSpec.describe TypeEvalRb::ComparisonTree do
  describe '.from_envs' do
    let(:expected) { FixturesHelper.expected_env('user_factory') }
    let(:actual) { FixturesHelper.actual_env('user_factory') }
    let(:comparison_tree) { described_class.from_envs(expected:, actual:) }

    it 'returns a comparison tree with class nodes from the given environments' do
      expect(comparison_tree.class_nodes.map(&:typename)).to contain_exactly(
        TypeHelper.type_name('::UserFactory'),
        TypeHelper.type_name('::User')
      )
    end
  end
end
