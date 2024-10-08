# frozen_string_literal: true

require_relative 'lib/type_eval_rb/version'

Gem::Specification.new do |spec|
  spec.name = 'type_eval_rb'
  spec.version = TypeEvalRb::VERSION
  spec.authors = ['kokuyouwind']
  spec.email = ['kokuyouwind@gmail.com']

  spec.summary = 'A Micro-benchmarking Framework for Ruby Type Inference Tools'
  spec.description = 'A Micro-benchmarking Framework for Ruby Type Inference Tools'
  spec.homepage = 'https://github.com/kokuyouwind/type_eval_rb'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.3.0'

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/kokuyouwind/type_eval_rb'
  spec.metadata['changelog_uri'] = 'https://github.com/kokuyouwind/type_eval_rb/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency 'rbs', '~> 3.5.1'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata['rubygems_mfa_required'] = 'true'
end
