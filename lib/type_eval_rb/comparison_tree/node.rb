# frozen_string_literal: true

module TypeEvalRb
  class ComparisonTree
    class Node
      def count_leaf
        raise NotImplementedError, "Subclasses must implement the 'count_leaf' method."
      end

      def count_matches
        raise NotImplementedError, "Subclasses must implement the 'count_matches' method."
      end

      def inspect
        raise NotImplementedError, "Subclasses must implement the 'to_s' method."
      end
    end
  end
end
