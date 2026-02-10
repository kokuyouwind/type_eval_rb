# Testing Strategy

This document outlines the testing strategy for TypeEvalRb.

## Testing Layers

### 1. Unit Tests

Unit tests focus on individual components in isolation.

#### ComparisonTree Nodes

Each node type should have tests for:
- **Initialization**: Verify all attributes are set correctly
- **Pretty-print**: Ensure correct formatting for debugging
- **Type comparison**: Test the comparison logic (to be implemented)
- **Metrics calculation**: Test count_leaf and count_matches (to be implemented)

Example test structure:
```ruby
RSpec.describe TypeEvalRb::ComparisonTree::TypeNode do
  describe '#initialize' do
    # Test attribute assignment
  end

  describe '#pretty_print' do
    # Test output formatting
  end

  describe '#matches?' do
    # Test type comparison logic (to be implemented)
  end

  describe '#count_leaf' do
    # Test leaf counting (to be implemented)
  end

  describe '#count_matches' do
    # Test match counting (to be implemented)
  end
end
```

#### Environment Loading

Test RBS file loading and parsing:
- Loading from valid paths
- Filtering class declarations correctly
- Error handling for invalid RBS files
- Multiple file handling

### 2. Integration Tests

Integration tests verify that components work correctly together.

#### Tree Construction

Test `ComparisonTree.from_envs` with various RBS signatures:
- Simple classes
- Classes with methods
- Classes with instance variables
- Classes with both methods and instance variables
- Multiple classes
- Inheritance hierarchies
- Generic classes

#### End-to-End Comparison

Test complete comparison workflows:
1. Load expected RBS from fixtures
2. Load actual RBS (or generate from test data)
3. Build comparison tree
4. Verify tree structure
5. Calculate and verify metrics

### 3. Fixture-Based Tests

Use real-world examples to test comprehensive scenarios.

#### Current Fixtures

Located in `spec/fixtures/examples/`:

1. **`test/`** - Basic class with simple method
   - Purpose: Baseline functionality test
   - Coverage: Class, method, basic types

2. **`multi_file_test/`** - Multiple classes across files
   - Purpose: Multi-file RBS loading
   - Coverage: Multiple class declarations

3. **`user_factory/`** - Factory pattern
   - Purpose: Instance variables and builder pattern
   - Coverage: Instance variables, method chaining

4. **`fix_errors_user_factory/`** - Same as above with errors
   - Purpose: Error case handling
   - Coverage: Type mismatches

5. **`with_errors/`** - Error scenarios
   - Purpose: Error handling
   - Coverage: Invalid or missing types

6. **`bird/`** - Inheritance
   - Purpose: Inheritance hierarchy comparison
   - Coverage: Class inheritance, method override

7. **`dynamic_definitions/`** - Dynamic methods
   - Purpose: Dynamically defined methods
   - Coverage: Meta-programming scenarios

8. **`namespace/`** - Namespaces
   - Purpose: Namespace handling
   - Coverage: Module namespacing

#### Needed Fixtures

To comprehensively test RBS features, we need additional fixtures:

##### Type System Fixtures

1. **`union_types/`** - Union type handling
   ```rbs
   def process: (Integer | String) -> void
   ```

2. **`optional_types/`** - Optional types
   ```rbs
   @name: String?
   def set_value: (?Integer) -> void
   ```

3. **`tuple_types/`** - Tuple types
   ```rbs
   def coordinates: () -> [Integer, Integer]
   ```

4. **`record_types/`** - Record types
   ```rbs
   def user_info: () -> { name: String, age: Integer }
   ```

5. **`intersection_types/`** - Intersection types
   ```rbs
   def reader_writer: (_Reader & _Writer) -> void
   ```

##### Method Signature Fixtures

6. **`keyword_params/`** - Keyword parameters
   ```rbs
   def create: (name: String, ?age: Integer) -> User
   ```

7. **`rest_params/`** - Rest parameters
   ```rbs
   def sum: (*Integer) -> Integer
   def merge: (**String) -> Hash[Symbol, String]
   ```

8. **`block_params/`** - Block parameters
   ```rbs
   def each: () { (String) -> void } -> void
   ```

9. **`method_overloading/`** - Method overloading
   ```rbs
   def add: (Integer) -> Integer
          | (String) -> String
   ```

10. **`singleton_methods/`** - Class methods
    ```rbs
    def self.create: (String) -> instance
    ```

##### Generic Type Fixtures

11. **`generic_class/`** - Generic class
    ```rbs
    class Container[T]
      def get: () -> T
      def set: (T) -> void
    end
    ```

12. **`variance/`** - Variance in generics
    ```rbs
    class CovariantList[out T]
    class ContravariantList[in T]
    ```

13. **`type_bounds/`** - Type parameter bounds
    ```rbs
    class Comparable[T < Numeric]
    ```

##### Module and Mixin Fixtures

14. **`module_inclusion/`** - Module include
    ```rbs
    module Enumerable[T]
      def each: () { (T) -> void } -> void
    end

    class MyList[T]
      include Enumerable[T]
    end
    ```

15. **`attributes/`** - Attributes
    ```rbs
    class User
      attr_reader name: String
      attr_writer age: Integer
      attr_accessor email: String
    end
    ```

##### Advanced Fixtures

16. **`interfaces/`** - Interface definitions
    ```rbs
    interface _ToJson
      def to_json: () -> String
    end
    ```

17. **`type_aliases/`** - Type aliases
    ```rbs
    type user_id = Integer
    type json = Integer | String | bool | Hash[String, json] | Array[json]
    ```

18. **`proc_types/`** - Proc types
    ```rbs
    def map: (^(String) -> Integer) -> Array[Integer]
    ```

19. **`visibility/`** - Method visibility
    ```rbs
    private def internal: () -> void
    public def api: () -> String
    ```

20. **`constants/`** - Constants and globals
    ```rbs
    VERSION: String
    $LOAD_PATH: Array[String]
    ```

### 4. Property-Based Tests (Future)

For comprehensive coverage, consider property-based testing:
- Generate random RBS signatures
- Verify invariants (e.g., count_leaf >= count_matches)
- Test comparison symmetry and transitivity

## Test Organization

```
spec/
├── type_eval_rb_spec.rb                    # Basic gem tests
├── type_eval_rb/
│   ├── environment_spec.rb                 # Environment loading tests
│   └── comparison_tree/
│       ├── type_node_spec.rb              # TypeNode unit tests
│       ├── argument_node_spec.rb          # ArgumentNode unit tests
│       ├── method_node_spec.rb            # MethodNode unit tests
│       ├── instance_variable_node_spec.rb # InstanceVariableNode unit tests
│       ├── class_node_spec.rb             # ClassNode unit tests
│       └── integration_spec.rb            # Integration tests (to be added)
├── fixtures/
│   └── examples/                          # Example RBS fixtures
│       ├── test/
│       ├── user_factory/
│       ├── bird/
│       ├── union_types/                   # To be added
│       ├── generic_class/                 # To be added
│       └── ...                            # More fixtures to be added
└── support/
    ├── fixtures_helper.rb                 # Fixture loading helpers
    ├── type_helper.rb                     # Type creation helpers
    └── pretty_print_shared_example.rb     # Shared examples
```

## Test Development Workflow

### For New RBS Features

1. **Create fixture**
   - Add example Ruby code in `lib/`
   - Add expected RBS in `sig/`
   - Optionally add actual (inferred) RBS in `refined/sig/` for mismatch testing

2. **Write unit test**
   - Test node creation from RBS AST
   - Test pretty-print output
   - Test comparison logic

3. **Write integration test**
   - Test full tree construction
   - Test metrics calculation
   - Verify expected behavior

4. **Document coverage**
   - Update implementation-status.md
   - Mark feature as implemented

### Test-Driven Development Approach

For implementing type comparison:

1. **Write failing test** showing expected behavior
2. **Implement minimal code** to make test pass
3. **Refactor** while keeping tests green
4. **Add edge cases** and repeat

Example:
```ruby
# 1. Write test
RSpec.describe TypeEvalRb::ComparisonTree::TypeNode do
  describe '#matches?' do
    it 'returns true for exact type match' do
      node = described_class.new(
        expected: TypeHelper.string,
        actual: TypeHelper.string
      )
      expect(node.matches?).to be true
    end
  end
end

# 2. Implement
def matches?
  expected == actual
end

# 3. Add edge cases
it 'returns true when actual is untyped' do
  node = described_class.new(
    expected: TypeHelper.string,
    actual: TypeHelper.untyped
  )
  expect(node.matches?).to be true
end
```

## Continuous Integration

Tests should run on:
- Multiple Ruby versions (3.3+)
- Different platforms (Linux, macOS, Windows)
- Pull requests and main branch

### CI Configuration

```yaml
# .github/workflows/test.yml
name: Test
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        ruby: ['3.3', '3.4']
    steps:
      - uses: actions/checkout@v2
      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: ${{ matrix.ruby }}
          bundler-cache: true
      - run: bundle exec rake spec
      - run: bundle exec rake rubocop
```

## Coverage Goals

- **Unit test coverage**: Aim for >90%
- **Integration test coverage**: All major feature combinations
- **Fixture coverage**: All RBS syntax features

Use SimpleCov to track coverage:
```ruby
# spec/spec_helper.rb
require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/vendor/'
end
```
