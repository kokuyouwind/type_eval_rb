# frozen_string_literal: true

module FixturesHelper
  class << self
    def fixtures_path
      File.expand_path('../fixtures', __dir__)
    end

    def fixture_path(dir)
      File.join(fixtures_path, dir)
    end

    def examples_path
      fixture_path('examples')
    end

    def example_path(example_name)
      File.join(examples_path, example_name)
    end

    def expected_sig_path(example_name)
      File.join(example_path(example_name), 'refined/sig')
    end

    def actual_sig_path(example_name)
      File.join(example_path(example_name), 'sig')
    end

    def expected_env(example_name)
      @expected_envs ||= {}
      @expected_envs[example_name] ||= TypeEvalRb::Environment.from_path(expected_sig_path(example_name))
    end

    def actual_env(example_name)
      @actual_envs ||= {}
      @actual_envs[example_name] ||= TypeEvalRb::Environment.from_path(actual_sig_path(example_name))
    end
  end
end
