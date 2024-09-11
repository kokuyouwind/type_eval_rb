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
  end
end
