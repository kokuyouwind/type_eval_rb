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

  describe '#count_leaf' do
    it 'sums parameters and return_type leaf counts' do
      expect(method_node.count_leaf).to eq(parameters.sum(&:count_leaf) + return_type.count_leaf)
    end
  end

  describe '#count_matches' do
    it 'sums parameters and return_type match counts' do
      expect(method_node.count_matches).to eq(parameters.sum(&:count_matches) + return_type.count_matches)
    end
  end

  describe '.from_ast' do
    subject(:node) { described_class.from_ast('greet', method_def, nil) }

    let(:env) { TypeEvalRb::Environment.from_path(FixturesHelper.example_path('optional_params')) }
    let(:class_decl) do
      env.class_decls[RBS::Namespace.parse('::OptionalParams').to_type_name].decls.first.decl
    end
    let(:method_def) { class_decl.members.find { |m| m.name.to_s == 'greet' } }

    it 'parses required positionals with required: true' do
      required = node.parameters.select(&:required)
      expect(required.size).to eq(1)
      expect(required.first.name).to eq('name')
    end

    it 'parses optional positionals with required: false' do
      optional = node.parameters.reject(&:required)
      expect(optional.size).to eq(1)
      expect(optional.first.name).to eq('title')
    end
  end

  describe '.from_ast with keyword parameters' do
    subject(:node) { described_class.from_ast('connect', method_def, nil) }

    let(:env) { TypeEvalRb::Environment.from_path(FixturesHelper.example_path('keyword_params')) }
    let(:class_decl) do
      env.class_decls[RBS::Namespace.parse('::KeywordParams').to_type_name].decls.first.decl
    end
    let(:method_def) { class_decl.members.find { |m| m.name.to_s == 'connect' } }

    it 'parses required keywords with param_type: :keyword and required: true' do
      req_kw = node.parameters.select { |p| p.param_type == :keyword && p.required }
      expect(req_kw.map(&:name)).to contain_exactly('host', 'port')
    end

    it 'parses optional keywords with param_type: :keyword and required: false' do
      opt_kw = node.parameters.select { |p| p.param_type == :keyword && !p.required }
      expect(opt_kw.size).to eq(1)
      expect(opt_kw.first.name).to eq('timeout')
    end
  end

  describe '#pretty_print' do
    let(:node) { method_node }

    it_behaves_like 'output expected pretty_print', <<~EXPECTED.strip
      MethodNode(name=foo,#{' '}
        parameters=[
          ArgumentNode(name=bar, required=true, param_type=positional,#{' '}
            type=TypeNode( expected="::String", actual="untyped"))
      #{'    '}
        ],
        return_type=TypeNode( expected="::String", actual="untyped"))
    EXPECTED
  end
end
