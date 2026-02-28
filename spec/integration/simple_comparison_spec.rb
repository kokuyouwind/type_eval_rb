# frozen_string_literal: true

RSpec.describe 'Simple type comparison (integration)' do
  let(:expected_path) { FixturesHelper.fixture_path('integration/expected') }
  let(:actual_path)   { FixturesHelper.fixture_path('integration/actual') }

  let(:expected_env) { TypeEvalRb::Environment.from_path(expected_path) }
  let(:actual_env)   { TypeEvalRb::Environment.from_path(actual_path) }

  let(:tree) { TypeEvalRb::ComparisonTree.from_envs(expected: expected_env, actual: actual_env) }

  describe 'tree structure' do
    it 'has one class node' do
      expect(tree.class_nodes.size).to eq(1)
    end

    it 'has correct class name' do
      expect(tree.class_nodes.first.typename.to_s).to eq('::Sample')
    end

    it 'has one instance variable node' do
      expect(tree.class_nodes.first.instance_variable_nodes.size).to eq(1)
    end

    it 'has two method nodes' do
      expect(tree.class_nodes.first.method_nodes.size).to eq(2)
    end
  end

  describe 'metrics' do
    # expected: @name(1) + greet return(1) + count param(1) + count return(1) = 4
    it 'has correct count_leaf' do
      expect(tree.count_leaf).to eq(4)
    end

    # matches: @name(1) + greet return(1) + count param Integer==Integer(1) + count return Integer!=String(0) = 3
    it 'has correct count_matches' do
      expect(tree.count_matches).to eq(3)
    end

    it 'has correct accuracy' do
      expect(tree.accuracy).to eq(0.75)
    end
  end
end
