# Implementation Status

This document tracks the current implementation status of TypeEvalRb.

## Overview

TypeEvalRb is a micro-benchmarking framework for Ruby type inference tools. It compares expected RBS type signatures against actual inferred types using a tree-based comparison structure.

## Current Implementation (Implemented Features)

### Core Data Structures

#### ComparisonTree (`lib/type_eval_rb/comparison_tree.rb`)
- ✅ Tree construction from two RBS environments (`from_envs`)
- ✅ Pretty-print support
- ❌ **Missing**: Metrics calculation (count_leaf, count_matches)

#### Node Types

##### ClassNode (`lib/type_eval_rb/comparison_tree/class_node.rb`)
- ✅ Class type name comparison
- ✅ Instance variable collection and comparison
- ✅ Method collection and comparison
- ✅ Construction from RBS AST declarations
- ✅ Pretty-print support
- ❌ **Missing**: Leaf counting and match counting
- ❌ **Missing**: Inheritance comparison
- ❌ **Missing**: Module mixins comparison (include/extend/prepend)
- ❌ **Missing**: Class/singleton method distinction
- ❌ **Missing**: Generic type parameters

##### MethodNode (`lib/type_eval_rb/comparison_tree/method_node.rb`)
- ✅ Method name comparison
- ✅ Required positional parameters comparison
- ✅ Return type comparison
- ✅ Pretty-print support
- ❌ **Missing**: Optional parameters
- ❌ **Missing**: Rest parameters (`*args`)
- ❌ **Missing**: Keyword parameters
- ❌ **Missing**: Block parameters
- ❌ **Missing**: Method overloading support
- ❌ **Missing**: Visibility (public/private/protected)
- ❌ **Missing**: Singleton method support (self.method_name)

##### InstanceVariableNode (`lib/type_eval_rb/comparison_tree/instance_variable_node.rb`)
- ✅ Instance variable name comparison
- ✅ Type comparison via TypeNode
- ✅ Pretty-print support
- ❌ **Missing**: Leaf counting and match counting
- ❌ **Missing**: Class instance variables (`self.@var`)

##### ArgumentNode (`lib/type_eval_rb/comparison_tree/argument_node.rb`)
- ✅ Parameter name storage
- ✅ Type comparison via TypeNode
- ✅ Pretty-print support
- ❌ **Missing**: Optional parameter indicator
- ❌ **Missing**: Rest parameter indicator
- ❌ **Missing**: Keyword parameter indicator

##### TypeNode (`lib/type_eval_rb/comparison_tree/type_node.rb`)
- ✅ Expected vs Actual type storage
- ✅ Basic type-to-string conversion (ClassInstance, Nil, Any/untyped)
- ✅ Pretty-print support
- ✅ Basic type comparison logic (`matches?` method)
  - ClassInstance exact match
  - untyped (Bases::Any) matches everything
  - Nil type comparison
  - nil actual returns false (missing type)
- ❌ **Missing**: Union type handling
- ❌ **Missing**: Intersection type handling
- ❌ **Missing**: Optional type handling (`Integer?`)
- ❌ **Missing**: Tuple type handling
- ❌ **Missing**: Record type handling
- ❌ **Missing**: Proc type handling
- ❌ **Missing**: Generic type parameter handling
- ❌ **Missing**: Literal type handling
- ❌ **Missing**: Special types (self, instance, class, bool, void, etc.)

### Environment Loading (`lib/type_eval_rb/environment.rb`)
- ✅ Load RBS files from a directory path
- ✅ Parse RBS with type name resolution
- ✅ Filter class declarations by path
- ❌ **Missing**: Interface loading
- ❌ **Missing**: Module loading (currently treated same as classes)
- ❌ **Missing**: Type alias loading
- ❌ **Missing**: Constant and global variable loading

### Test Coverage

#### Unit Tests
- ✅ Environment initialization and path loading
- ✅ TypeNode initialization and pretty-print
- ✅ ArgumentNode initialization and pretty-print
- ✅ MethodNode initialization and pretty-print
- ✅ ClassNode initialization and pretty-print
- ✅ InstanceVariableNode initialization and pretty-print

#### Test Fixtures
Available examples in `spec/fixtures/examples/`:
- `test/` - Basic class with method
- `multi_file_test/` - Multiple classes across files
- `user_factory/` - Factory pattern with instance variables
- `fix_errors_user_factory/` - Same as above with error cases
- `with_errors/` - Error handling test case
- `bird/` - Inheritance example (Bird < Duck, Goose)
- `dynamic_definitions/` - Dynamic method definitions
- `namespace/` - Namespace handling

## Missing Core Functionality

### 1. Type Comparison Logic
The TypeNode class stores expected and actual types but doesn't implement any comparison logic. Need to implement:
- Exact match checking
- Subtype/supertype relationship checking
- Union/intersection type comparison
- Generic type parameter matching
- Handling of `untyped` (universal type)

### 2. Metrics Calculation
The base Node class defines `count_leaf` and `count_matches` but none of the subclasses implement them. These are essential for benchmarking:
- `count_leaf`: Count total number of type comparisons
- `count_matches`: Count number of matching types

### 3. Advanced RBS Features
Many RBS features are not yet supported:
- Method overloading
- Generic type parameters with variance and bounds
- Interface definitions
- Type aliases
- Module mixins (include/extend/prepend)
- Visibility modifiers
- Attributes (attr_reader, attr_writer, attr_accessor)
- Class variables and constants
- Global variables
- Proc types with self-type binding

## Implementation Priority

### Phase 1: Core Comparison Logic (High Priority)
1. Implement type comparison in TypeNode
2. Implement count_leaf and count_matches in all nodes
3. Add basic metrics output

### Phase 2: Method Signatures (High Priority)
1. Support optional parameters
2. Support keyword parameters
3. Support rest parameters
4. Support block parameters
5. Support singleton methods

### Phase 3: Type System Coverage (Medium Priority)
1. Union types (`Integer | String`)
2. Intersection types (`_Reader & _Writer`)
3. Optional types (`Integer?`)
4. Tuple types (`[Integer, String]`)
5. Record types (`{ id: Integer, name: String }`)
6. Generic type parameters

### Phase 4: Advanced Features (Low Priority)
1. Method overloading
2. Interface definitions
3. Type aliases
4. Module mixins
5. Attributes
6. Proc types
7. Variance and bounds for generics

## Testing Strategy

### Unit Tests
Each feature implementation should include:
- Initialization tests
- Comparison logic tests
- Metrics calculation tests
- Edge case handling

### Integration Tests
After core comparison logic is implemented:
- Compare simple class definitions
- Compare inheritance hierarchies
- Compare generic classes
- Compare modules and interfaces

### Benchmark Tests
Using real-world RBS signatures:
- Standard library classes (Array, Hash, String, etc.)
- Popular gems
- Complex type inference scenarios
