# frozen_string_literal: true

RSpec.describe TypeEvalRb::Environment do
  describe '#initialize' do
    subject { described_class.new(class_decls:) }

    let(:name) { TypeHelper.type_name('::Hoge') }
    let(:class_decls) { { name => RBS::Environment::ClassEntry.new(name:) } }

    it 'sets the class declarations' do
      expect(subject.class_decls).to eq(class_decls)
    end
  end

  describe '.from_path' do
    subject { described_class.from_path(path) }

    let(:path) { FixturesHelper.example_path('user_factory') }
    let(:user_factory_name) { TypeHelper.type_name('::UserFactory') }
    let(:user_name) { TypeHelper.type_name('::User') }

    it 'returns an environment with class declarations from the given path' do
      expect(subject.class_decls.keys).to contain_exactly(user_factory_name, user_name)
      expect(subject.class_decls[user_factory_name]).to be_a(RBS::Environment::ClassEntry)
        .and have_attributes(name: user_factory_name)
      expect(subject.class_decls[user_name]).to be_a(RBS::Environment::ClassEntry)
        .and have_attributes(name: user_name)
    end
  end
end
