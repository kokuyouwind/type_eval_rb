# frozen_string_literal: true

module TypeEvalRb
  class Environment
    attr_reader :class_decls

    def initialize(class_decls:)
      @class_decls = class_decls
    end

    class << self
      def from_path(path)
        loader = RBS::EnvironmentLoader.new
        loader.add(path: Pathname(path))
        env = RBS::Environment.from_loader(loader).resolve_type_names
        class_decls = env.class_decls.filter do |_, v|
          v.primary.decl.location.name.start_with?(path)
        end
        new(class_decls:)
      end
    end
  end
end
