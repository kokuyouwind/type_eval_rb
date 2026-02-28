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

    it 'defaults kind to :instance' do
      expect(subject.kind).to eq(:instance)
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

  describe '.from_ast with singleton method' do
    let(:env) { TypeEvalRb::Environment.from_path(FixturesHelper.example_path('singleton_methods')) }
    let(:class_decl) do
      env.class_decls[RBS::Namespace.parse('::SingletonMethods').to_type_name].decls.first.decl
    end

    context 'with singleton: true' do
      subject(:node) { described_class.from_ast('create', method_def, nil, kind: :singleton) }

      let(:method_def) { class_decl.members.find { |m| m.name.to_s == 'create' && m.singleton? } }

      it 'sets kind to :singleton' do
        expect(node.kind).to eq(:singleton)
      end
    end

    context 'without singleton flag' do
      subject(:node) { described_class.from_ast('greet', method_def, nil) }

      let(:method_def) { class_decl.members.find { |m| m.name.to_s == 'greet' && !m.singleton? } }

      it 'defaults kind to :instance' do
        expect(node.kind).to eq(:instance)
      end
    end
  end

  describe '.from_ast with block parameter' do
    subject(:node) { described_class.from_ast('each', method_def, nil) }

    let(:env) { TypeEvalRb::Environment.from_path(FixturesHelper.example_path('block_params')) }
    let(:class_decl) do
      env.class_decls[RBS::Namespace.parse('::BlockParams').to_type_name].decls.first.decl
    end
    let(:method_def) { class_decl.members.find { |m| m.name.to_s == 'each' } }

    it 'sets block to a TypeNode' do
      expect(node.block).to be_a(TypeEvalRb::ComparisonTree::TypeNode)
    end

    it 'includes block in count_leaf' do
      expect(node.count_leaf).to eq(node.parameters.sum(&:count_leaf) + node.return_type.count_leaf + 1)
    end
  end

  describe '.from_ast with rest parameters' do
    let(:env) { TypeEvalRb::Environment.from_path(FixturesHelper.example_path('rest_params')) }
    let(:class_decl) do
      env.class_decls[RBS::Namespace.parse('::RestParams').to_type_name].decls.first.decl
    end

    context 'with rest positionals (*args)' do
      subject(:node) { described_class.from_ast('log', method_def, nil) }

      let(:method_def) { class_decl.members.find { |m| m.name.to_s == 'log' } }

      it 'marks rest positional with rest: true' do
        rest = node.parameters.select(&:rest)
        expect(rest.size).to eq(1)
        expect(rest.first.param_type).to eq(:positional)
      end
    end

    context 'with rest keywords (**opts)' do
      subject(:node) { described_class.from_ast('configure', method_def, nil) }

      let(:method_def) { class_decl.members.find { |m| m.name.to_s == 'configure' } }

      it 'marks rest keyword with rest: true and param_type: :keyword' do
        rest = node.parameters.select(&:rest)
        expect(rest.size).to eq(1)
        expect(rest.first.param_type).to eq(:keyword)
      end
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
          ArgumentNode(name=bar, required=true, param_type=positional, rest=false,#{' '}
            type=TypeNode( expected="::String", actual="untyped"))
      #{'    '}
        ],
        return_type=TypeNode( expected="::String", actual="untyped"))
    EXPECTED
  end
end
