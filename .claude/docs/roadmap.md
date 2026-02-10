# Development Roadmap

This document outlines the development roadmap for TypeEvalRb.

## Project Goals

TypeEvalRb aims to be a comprehensive micro-benchmarking framework for Ruby type inference tools by:
1. Supporting all RBS type signature features
2. Providing accurate type comparison metrics
3. Offering detailed mismatch analysis
4. Supporting real-world benchmarking scenarios

---

## Detailed Task Checklist

This checklist provides fine-grained, sequential tasks. Complete them in order from top to bottom.

### Phase 1: Core Type Comparison (Priority: HIGH)

**Goal**: Implement basic type comparison logic and metrics calculation.

#### 1.1 TypeNode Comparison Logic (Basic Types)

- [ ] 1.1.1: Add `matches?` method skeleton to TypeNode class (lib/type_eval_rb/comparison_tree/type_node.rb)
- [ ] 1.1.2: Write unit test: TypeNode#matches? returns true for identical ClassInstance types
- [ ] 1.1.3: Implement exact ClassInstance type matching in `matches?` method
- [ ] 1.1.4: Write unit test: TypeNode#matches? returns true when actual is untyped
- [ ] 1.1.5: Implement untyped handling (untyped matches everything) in `matches?`
- [ ] 1.1.6: Write unit test: TypeNode#matches? returns true when expected is untyped
- [ ] 1.1.7: Implement untyped handling for expected type in `matches?`
- [ ] 1.1.8: Write unit test: TypeNode#matches? handles nil type correctly
- [ ] 1.1.9: Implement nil type matching in `matches?`
- [ ] 1.1.10: Write unit test: TypeNode#matches? returns false for mismatched types
- [ ] 1.1.11: Verify mismatched type handling works correctly
- [ ] 1.1.12: Write unit test: TypeNode#matches? handles nil actual gracefully
- [ ] 1.1.13: Implement nil actual handling (treat as missing type, returns false)
- [ ] 1.1.14: Update TypeNode#type_to_string to handle Bases::Nil type
- [ ] 1.1.15: Update TypeNode#type_to_string to handle Bases::Any (untyped) type
- [ ] 1.1.16: Run all TypeNode tests and verify they pass
- [ ] 1.1.17: Update implementation-status.md to mark TypeNode basic comparison as implemented

#### 1.2 TypeNode Metrics (Leaf Counting)

- [ ] 1.2.1: Add `count_leaf` method skeleton to TypeNode class
- [ ] 1.2.2: Write unit test: TypeNode#count_leaf returns 1 (TypeNode is always a leaf)
- [ ] 1.2.3: Implement `count_leaf` to return 1
- [ ] 1.2.4: Run TypeNode tests and verify they pass

#### 1.3 TypeNode Metrics (Match Counting)

- [ ] 1.3.1: Add `count_matches` method skeleton to TypeNode class
- [ ] 1.3.2: Write unit test: TypeNode#count_matches returns 1 when types match
- [ ] 1.3.3: Write unit test: TypeNode#count_matches returns 0 when types don't match
- [ ] 1.3.4: Implement `count_matches` using `matches?` method
- [ ] 1.3.5: Run TypeNode tests and verify they pass
- [ ] 1.3.6: Update implementation-status.md to mark TypeNode metrics as implemented

#### 1.4 ArgumentNode Metrics

- [ ] 1.4.1: Add `count_leaf` method to ArgumentNode class
- [ ] 1.4.2: Write unit test: ArgumentNode#count_leaf delegates to type.count_leaf
- [ ] 1.4.3: Implement `count_leaf` to delegate to @type.count_leaf
- [ ] 1.4.4: Add `count_matches` method to ArgumentNode class
- [ ] 1.4.5: Write unit test: ArgumentNode#count_matches delegates to type.count_matches
- [ ] 1.4.6: Implement `count_matches` to delegate to @type.count_matches
- [ ] 1.4.7: Run ArgumentNode tests and verify they pass
- [ ] 1.4.8: Update implementation-status.md to mark ArgumentNode metrics as implemented

#### 1.5 InstanceVariableNode Metrics

- [ ] 1.5.1: Add `count_leaf` method to InstanceVariableNode class
- [ ] 1.5.2: Write unit test: InstanceVariableNode#count_leaf delegates to type.count_leaf
- [ ] 1.5.3: Implement `count_leaf` to delegate to @type.count_leaf
- [ ] 1.5.4: Add `count_matches` method to InstanceVariableNode class
- [ ] 1.5.5: Write unit test: InstanceVariableNode#count_matches delegates to type.count_matches
- [ ] 1.5.6: Implement `count_matches` to delegate to @type.count_matches
- [ ] 1.5.7: Run InstanceVariableNode tests and verify they pass
- [ ] 1.5.8: Update implementation-status.md to mark InstanceVariableNode metrics as implemented

#### 1.6 MethodNode Metrics

- [ ] 1.6.1: Add `count_leaf` method to MethodNode class
- [ ] 1.6.2: Write unit test: MethodNode#count_leaf sums parameters and return_type leaf counts
- [ ] 1.6.3: Implement `count_leaf` to sum @parameters.sum(&:count_leaf) + @return_type.count_leaf
- [ ] 1.6.4: Add `count_matches` method to MethodNode class
- [ ] 1.6.5: Write unit test: MethodNode#count_matches sums parameters and return_type match counts
- [ ] 1.6.6: Implement `count_matches` to sum matches from parameters and return_type
- [ ] 1.6.7: Run MethodNode tests and verify they pass
- [ ] 1.6.8: Update implementation-status.md to mark MethodNode metrics as implemented

#### 1.7 ClassNode Metrics

- [ ] 1.7.1: Add `count_leaf` method to ClassNode class
- [ ] 1.7.2: Write unit test: ClassNode#count_leaf sums instance_variables and methods leaf counts
- [ ] 1.7.3: Implement `count_leaf` to sum from @instance_variable_nodes and @method_nodes
- [ ] 1.7.4: Add `count_matches` method to ClassNode class
- [ ] 1.7.5: Write unit test: ClassNode#count_matches sums instance_variables and methods match counts
- [ ] 1.7.6: Implement `count_matches` to sum matches from instance_variables and methods
- [ ] 1.7.7: Run ClassNode tests and verify they pass
- [ ] 1.7.8: Update implementation-status.md to mark ClassNode metrics as implemented

#### 1.8 ComparisonTree Metrics Aggregation

- [ ] 1.8.1: Add `count_leaf` method to ComparisonTree class
- [ ] 1.8.2: Write unit test: ComparisonTree#count_leaf sums all class_nodes leaf counts
- [ ] 1.8.3: Implement `count_leaf` to sum @class_nodes.sum(&:count_leaf)
- [ ] 1.8.4: Add `count_matches` method to ComparisonTree class
- [ ] 1.8.5: Write unit test: ComparisonTree#count_matches sums all class_nodes match counts
- [ ] 1.8.6: Implement `count_matches` to sum @class_nodes.sum(&:count_matches)
- [ ] 1.8.7: Add `accuracy` method to ComparisonTree class
- [ ] 1.8.8: Write unit test: ComparisonTree#accuracy returns count_matches / count_leaf as Float
- [ ] 1.8.9: Implement `accuracy` to calculate and return accuracy percentage
- [ ] 1.8.10: Write unit test: ComparisonTree#accuracy handles zero leaves gracefully
- [ ] 1.8.11: Update `accuracy` to return 0.0 when count_leaf is 0
- [ ] 1.8.12: Run ComparisonTree tests and verify they pass
- [ ] 1.8.13: Update implementation-status.md to mark tree-level metrics as implemented

#### 1.9 Integration Test for Phase 1

- [ ] 1.9.1: Create integration test file: spec/integration/simple_comparison_spec.rb
- [ ] 1.9.2: Write integration test: Load user_factory fixture and build comparison tree
- [ ] 1.9.3: Write integration test: Verify tree structure is correct
- [ ] 1.9.4: Write integration test: Calculate and verify metrics (count_leaf, count_matches, accuracy)
- [ ] 1.9.5: Run integration tests and verify they pass
- [ ] 1.9.6: Update CLAUDE.md to mention integration tests
- [ ] 1.9.7: Update implementation-status.md to mark Phase 1 as complete

---

### Phase 2: Method Signature Support (Priority: HIGH)

**Goal**: Support comprehensive method signature comparison.

#### 2.1 Optional Positional Parameters

- [ ] 2.1.1: Add `required` attribute (boolean) to ArgumentNode class
- [ ] 2.1.2: Update ArgumentNode#initialize to accept `required:` parameter (default: true)
- [ ] 2.1.3: Update ArgumentNode unit test to verify required attribute
- [ ] 2.1.4: Update ArgumentNode#pretty_print to show required/optional status
- [ ] 2.1.5: Update MethodNode.from_ast to detect optional parameters from RBS AST
- [ ] 2.1.6: Write unit test: MethodNode.from_ast handles optional_positionals correctly
- [ ] 2.1.7: Implement optional parameter parsing in MethodNode.from_ast
- [ ] 2.1.8: Create fixture: spec/fixtures/examples/optional_params/
- [ ] 2.1.9: Add Ruby code with optional parameters to fixture
- [ ] 2.1.10: Add expected RBS with optional parameters to fixture
- [ ] 2.1.11: Write integration test for optional parameters using new fixture
- [ ] 2.1.12: Run tests and verify they pass
- [ ] 2.1.13: Update implementation-status.md to mark optional parameters as implemented

#### 2.2 Keyword Parameters (Required)

- [ ] 2.2.1: Add `param_type` attribute (enum: :positional, :keyword) to ArgumentNode class
- [ ] 2.2.2: Update ArgumentNode#initialize to accept `param_type:` parameter (default: :positional)
- [ ] 2.2.3: Update ArgumentNode unit test to verify param_type attribute
- [ ] 2.2.4: Update ArgumentNode#pretty_print to show parameter type
- [ ] 2.2.5: Update MethodNode.from_ast to parse required keywords from RBS AST
- [ ] 2.2.6: Write unit test: MethodNode.from_ast handles required_keywords correctly
- [ ] 2.2.7: Implement required keyword parameter parsing in MethodNode.from_ast
- [ ] 2.2.8: Run tests and verify they pass

#### 2.3 Keyword Parameters (Optional)

- [ ] 2.3.1: Update MethodNode.from_ast to parse optional keywords from RBS AST
- [ ] 2.3.2: Write unit test: MethodNode.from_ast handles optional_keywords correctly
- [ ] 2.3.3: Implement optional keyword parameter parsing in MethodNode.from_ast
- [ ] 2.3.4: Create fixture: spec/fixtures/examples/keyword_params/
- [ ] 2.3.5: Add Ruby code with required and optional keyword parameters to fixture
- [ ] 2.3.6: Add expected RBS with keyword parameters to fixture
- [ ] 2.3.7: Write integration test for keyword parameters using new fixture
- [ ] 2.3.8: Run tests and verify they pass
- [ ] 2.3.9: Update implementation-status.md to mark keyword parameters as implemented

#### 2.4 Rest Parameters (Positional)

- [ ] 2.4.1: Add `rest` attribute (boolean) to ArgumentNode class
- [ ] 2.4.2: Update ArgumentNode#initialize to accept `rest:` parameter (default: false)
- [ ] 2.4.3: Update ArgumentNode unit test to verify rest attribute
- [ ] 2.4.4: Update ArgumentNode#pretty_print to show rest parameter indicator
- [ ] 2.4.5: Update MethodNode.from_ast to parse rest_positionals from RBS AST
- [ ] 2.4.6: Write unit test: MethodNode.from_ast handles rest_positionals correctly
- [ ] 2.4.7: Implement rest positional parameter parsing in MethodNode.from_ast
- [ ] 2.4.8: Run tests and verify they pass

#### 2.5 Rest Parameters (Keyword)

- [ ] 2.5.1: Update MethodNode.from_ast to parse rest_keywords from RBS AST
- [ ] 2.5.2: Write unit test: MethodNode.from_ast handles rest_keywords correctly
- [ ] 2.5.3: Implement keyword rest parameter parsing in MethodNode.from_ast
- [ ] 2.5.4: Create fixture: spec/fixtures/examples/rest_params/
- [ ] 2.5.5: Add Ruby code with rest parameters to fixture
- [ ] 2.5.6: Add expected RBS with rest parameters to fixture
- [ ] 2.5.7: Write integration test for rest parameters using new fixture
- [ ] 2.5.8: Run tests and verify they pass
- [ ] 2.5.9: Update implementation-status.md to mark rest parameters as implemented

#### 2.6 Block Parameters

- [ ] 2.6.1: Add `block` attribute (TypeNode or nil) to MethodNode class
- [ ] 2.6.2: Update MethodNode#initialize to accept `block:` parameter (default: nil)
- [ ] 2.6.3: Update MethodNode unit test to verify block attribute
- [ ] 2.6.4: Update MethodNode#pretty_print to show block parameter
- [ ] 2.6.5: Update MethodNode#count_leaf to include block leaf count if present
- [ ] 2.6.6: Update MethodNode#count_matches to include block match count if present
- [ ] 2.6.7: Update MethodNode.from_ast to parse block from RBS AST
- [ ] 2.6.8: Write unit test: MethodNode.from_ast handles block parameter correctly
- [ ] 2.6.9: Implement block parameter parsing in MethodNode.from_ast
- [ ] 2.6.10: Create fixture: spec/fixtures/examples/block_params/
- [ ] 2.6.11: Add Ruby code with block parameters to fixture
- [ ] 2.6.12: Add expected RBS with block parameters to fixture
- [ ] 2.6.13: Write integration test for block parameters using new fixture
- [ ] 2.6.14: Run tests and verify they pass
- [ ] 2.6.15: Update implementation-status.md to mark block parameters as implemented

#### 2.7 Singleton Methods

- [ ] 2.7.1: Add `kind` attribute (enum: :instance, :singleton) to MethodNode class
- [ ] 2.7.2: Update MethodNode#initialize to accept `kind:` parameter (default: :instance)
- [ ] 2.7.3: Update MethodNode unit test to verify kind attribute
- [ ] 2.7.4: Update MethodNode#pretty_print to show method kind
- [ ] 2.7.5: Update MethodNode.from_ast to detect singleton methods from RBS AST
- [ ] 2.7.6: Write unit test: MethodNode.from_ast handles singleton methods correctly
- [ ] 2.7.7: Implement singleton method detection in MethodNode.from_ast
- [ ] 2.7.8: Update ClassNode.methods_to_nodes to handle both instance and singleton methods
- [ ] 2.7.9: Create fixture: spec/fixtures/examples/singleton_methods/
- [ ] 2.7.10: Add Ruby code with singleton methods to fixture
- [ ] 2.7.11: Add expected RBS with singleton methods to fixture
- [ ] 2.7.12: Write integration test for singleton methods using new fixture
- [ ] 2.7.13: Run tests and verify they pass
- [ ] 2.7.14: Update implementation-status.md to mark singleton methods as implemented
- [ ] 2.7.15: Update implementation-status.md to mark Phase 2 as complete

---

### Phase 3: Type System Coverage (Priority: MEDIUM)

**Goal**: Support RBS composite and special types.

#### 3.1 Union Types (Parsing)

- [ ] 3.1.1: Research RBS::Types::Union structure in RBS gem
- [ ] 3.1.2: Update TypeNode#type_to_string to handle Union types
- [ ] 3.1.3: Write unit test: TypeNode#type_to_string formats union types correctly
- [ ] 3.1.4: Implement union type formatting in type_to_string
- [ ] 3.1.5: Run tests and verify they pass

#### 3.2 Union Types (Comparison)

- [ ] 3.2.1: Write unit test: TypeNode#matches? handles exact union match (same types, same order)
- [ ] 3.2.2: Implement basic union comparison in matches? method
- [ ] 3.2.3: Write unit test: TypeNode#matches? handles union match (same types, different order)
- [ ] 3.2.4: Implement order-independent union comparison
- [ ] 3.2.5: Write unit test: TypeNode#matches? handles subset union (actual is more specific)
- [ ] 3.2.6: Implement subset union comparison
- [ ] 3.2.7: Write unit test: TypeNode#matches? handles simple type matching union
- [ ] 3.2.8: Implement simple type matching against union
- [ ] 3.2.9: Run tests and verify they pass

#### 3.3 Union Types (Nested and Fixtures)

- [ ] 3.3.1: Write unit test: TypeNode#matches? handles nested unions
- [ ] 3.3.2: Implement nested union comparison
- [ ] 3.3.3: Create fixture: spec/fixtures/examples/union_types/
- [ ] 3.3.4: Add Ruby code with union types to fixture
- [ ] 3.3.5: Add expected RBS with union types to fixture
- [ ] 3.3.6: Write integration test for union types using new fixture
- [ ] 3.3.7: Run tests and verify they pass
- [ ] 3.3.8: Update implementation-status.md to mark union types as implemented

#### 3.4 Optional Types

- [ ] 3.4.1: Research RBS::Types::Optional structure in RBS gem
- [ ] 3.4.2: Update TypeNode#type_to_string to handle Optional types
- [ ] 3.4.3: Write unit test: TypeNode#type_to_string formats optional types correctly
- [ ] 3.4.4: Implement optional type formatting
- [ ] 3.4.5: Write unit test: TypeNode#matches? treats Optional[T] as T | nil
- [ ] 3.4.6: Implement optional type normalization and comparison
- [ ] 3.4.7: Create fixture: spec/fixtures/examples/optional_types/
- [ ] 3.4.8: Add Ruby code with optional types to fixture
- [ ] 3.4.9: Add expected RBS with optional types to fixture
- [ ] 3.4.10: Write integration test for optional types using new fixture
- [ ] 3.4.11: Run tests and verify they pass
- [ ] 3.4.12: Update implementation-status.md to mark optional types as implemented

#### 3.5 Tuple Types

- [ ] 3.5.1: Research RBS::Types::Tuple structure in RBS gem
- [ ] 3.5.2: Update TypeNode#type_to_string to handle Tuple types
- [ ] 3.5.3: Write unit test: TypeNode#type_to_string formats tuple types correctly
- [ ] 3.5.4: Implement tuple type formatting
- [ ] 3.5.5: Write unit test: TypeNode#matches? compares tuples element-wise
- [ ] 3.5.6: Implement tuple element-wise comparison
- [ ] 3.5.7: Write unit test: TypeNode#matches? handles different length tuples
- [ ] 3.5.8: Implement length checking for tuples
- [ ] 3.5.9: Create fixture: spec/fixtures/examples/tuple_types/
- [ ] 3.5.10: Add Ruby code with tuple types to fixture
- [ ] 3.5.11: Add expected RBS with tuple types to fixture
- [ ] 3.5.12: Write integration test for tuple types using new fixture
- [ ] 3.5.13: Run tests and verify they pass
- [ ] 3.5.14: Update implementation-status.md to mark tuple types as implemented

#### 3.6 Record Types

- [ ] 3.6.1: Research RBS::Types::Record structure in RBS gem
- [ ] 3.6.2: Update TypeNode#type_to_string to handle Record types
- [ ] 3.6.3: Write unit test: TypeNode#type_to_string formats record types correctly
- [ ] 3.6.4: Implement record type formatting
- [ ] 3.6.5: Write unit test: TypeNode#matches? compares records key-by-key
- [ ] 3.6.6: Implement record key-value comparison
- [ ] 3.6.7: Write unit test: TypeNode#matches? handles missing record keys
- [ ] 3.6.8: Implement missing key handling for records
- [ ] 3.6.9: Create fixture: spec/fixtures/examples/record_types/
- [ ] 3.6.10: Add Ruby code with record types to fixture
- [ ] 3.6.11: Add expected RBS with record types to fixture
- [ ] 3.6.12: Write integration test for record types using new fixture
- [ ] 3.6.13: Run tests and verify they pass
- [ ] 3.6.14: Update implementation-status.md to mark record types as implemented

#### 3.7 Intersection Types

- [ ] 3.7.1: Research RBS::Types::Intersection structure in RBS gem
- [ ] 3.7.2: Update TypeNode#type_to_string to handle Intersection types
- [ ] 3.7.3: Write unit test: TypeNode#type_to_string formats intersection types correctly
- [ ] 3.7.4: Implement intersection type formatting
- [ ] 3.7.5: Write unit test: TypeNode#matches? compares intersection types
- [ ] 3.7.6: Implement intersection type comparison (all components must match)
- [ ] 3.7.7: Create fixture: spec/fixtures/examples/intersection_types/
- [ ] 3.7.8: Add Ruby code with intersection types to fixture
- [ ] 3.7.9: Add expected RBS with intersection types to fixture
- [ ] 3.7.10: Write integration test for intersection types using new fixture
- [ ] 3.7.11: Run tests and verify they pass
- [ ] 3.7.12: Update implementation-status.md to mark intersection types as implemented

#### 3.8 Special Types (bool, void)

- [ ] 3.8.1: Research RBS special type structures (Bases::Bool, Bases::Void, etc.)
- [ ] 3.8.2: Update TypeNode#type_to_string to handle bool type
- [ ] 3.8.3: Update TypeNode#type_to_string to handle void type
- [ ] 3.8.4: Write unit test: TypeNode#matches? handles bool type correctly
- [ ] 3.8.5: Write unit test: TypeNode#matches? handles void type correctly
- [ ] 3.8.6: Implement bool and void type comparison
- [ ] 3.8.7: Run tests and verify they pass

#### 3.9 Special Types (self, instance, class)

- [ ] 3.9.1: Research RBS::Types::Bases::Self, Instance, Class structures
- [ ] 3.9.2: Update TypeNode#type_to_string to handle self type
- [ ] 3.9.3: Update TypeNode#type_to_string to handle instance type
- [ ] 3.9.4: Update TypeNode#type_to_string to handle class type
- [ ] 3.9.5: Write unit test: TypeNode#matches? handles self type correctly
- [ ] 3.9.6: Write unit test: TypeNode#matches? handles instance type correctly
- [ ] 3.9.7: Write unit test: TypeNode#matches? handles class type correctly
- [ ] 3.9.8: Implement self, instance, class type comparison
- [ ] 3.9.9: Run tests and verify they pass

#### 3.10 Special Types (top, bot)

- [ ] 3.10.1: Research RBS::Types::Bases::Top and Bot structures
- [ ] 3.10.2: Update TypeNode#type_to_string to handle top type
- [ ] 3.10.3: Update TypeNode#type_to_string to handle bot type
- [ ] 3.10.4: Write unit test: TypeNode#matches? handles top type (supertype of all)
- [ ] 3.10.5: Write unit test: TypeNode#matches? handles bot type (subtype of all)
- [ ] 3.10.6: Implement top and bot type comparison
- [ ] 3.10.7: Create fixture: spec/fixtures/examples/special_types/
- [ ] 3.10.8: Add Ruby code with special types to fixture
- [ ] 3.10.9: Add expected RBS with special types to fixture
- [ ] 3.10.10: Write integration test for special types using new fixture
- [ ] 3.10.11: Run tests and verify they pass
- [ ] 3.10.12: Update implementation-status.md to mark special types as implemented
- [ ] 3.10.13: Update implementation-status.md to mark Phase 3 as complete

---

### Phase 4: Generic Type Parameters (Priority: MEDIUM)

**Goal**: Support generic types with parameters, variance, and bounds.

#### 4.1 Basic Generics (Parsing)

- [ ] 4.1.1: Add `type_params` attribute (Array) to ClassNode class
- [ ] 4.1.2: Update ClassNode#initialize to accept `type_params:` parameter (default: [])
- [ ] 4.1.3: Update ClassNode unit test to verify type_params attribute
- [ ] 4.1.4: Update ClassNode.from_decls to extract type parameters from RBS declaration
- [ ] 4.1.5: Write unit test: ClassNode.from_decls parses generic type parameters
- [ ] 4.1.6: Implement type parameter extraction in ClassNode.from_decls
- [ ] 4.1.7: Run tests and verify they pass

#### 4.2 Basic Generics (Comparison)

- [ ] 4.2.1: Update ClassNode#pretty_print to show type parameters
- [ ] 4.2.2: Write unit test: ClassNode with matching type parameters
- [ ] 4.2.3: Write unit test: ClassNode with mismatched type parameter count
- [ ] 4.2.4: Create fixture: spec/fixtures/examples/generic_class/
- [ ] 4.2.5: Add Ruby code with generic class to fixture
- [ ] 4.2.6: Add expected RBS with generic class to fixture
- [ ] 4.2.7: Write integration test for generic classes using new fixture
- [ ] 4.2.8: Run tests and verify they pass
- [ ] 4.2.9: Update implementation-status.md to mark basic generics as implemented

#### 4.3 Generic Type Instantiation

- [ ] 4.3.1: Research RBS::Types::ClassInstance with type arguments
- [ ] 4.3.2: Update TypeNode#type_to_string to show type arguments for ClassInstance
- [ ] 4.3.3: Write unit test: TypeNode#matches? compares generic instantiations
- [ ] 4.3.4: Write unit test: Array[String] matches Array[String] but not Array[Integer]
- [ ] 4.3.5: Implement generic type argument comparison in TypeNode#matches?
- [ ] 4.3.6: Create fixture: spec/fixtures/examples/generic_instantiation/
- [ ] 4.3.7: Add Ruby code using instantiated generics to fixture
- [ ] 4.3.8: Add expected RBS with instantiated generics to fixture
- [ ] 4.3.9: Write integration test for generic instantiation using new fixture
- [ ] 4.3.10: Run tests and verify they pass
- [ ] 4.3.11: Update implementation-status.md to mark generic instantiation as implemented

#### 4.4 Type Parameter Variance

- [ ] 4.4.1: Research RBS type parameter variance (covariant, contravariant, invariant)
- [ ] 4.4.2: Store variance information in ClassNode type_params
- [ ] 4.4.3: Write unit test: ClassNode stores variance for each type parameter
- [ ] 4.4.4: Implement variance extraction in ClassNode.from_decls
- [ ] 4.4.5: Update ClassNode#pretty_print to show variance
- [ ] 4.4.6: Create fixture: spec/fixtures/examples/variance/
- [ ] 4.4.7: Add Ruby code with covariant/contravariant types to fixture
- [ ] 4.4.8: Add expected RBS with variance annotations to fixture
- [ ] 4.4.9: Write integration test for variance using new fixture
- [ ] 4.4.10: Run tests and verify they pass
- [ ] 4.4.11: Update implementation-status.md to mark variance as implemented

#### 4.5 Type Parameter Bounds

- [ ] 4.5.1: Research RBS type parameter bounds (upper/lower)
- [ ] 4.5.2: Store bound information in ClassNode type_params
- [ ] 4.5.3: Write unit test: ClassNode stores bounds for type parameters
- [ ] 4.5.4: Implement bounds extraction in ClassNode.from_decls
- [ ] 4.5.5: Update ClassNode#pretty_print to show bounds
- [ ] 4.5.6: Create fixture: spec/fixtures/examples/type_bounds/
- [ ] 4.5.7: Add Ruby code with bounded type parameters to fixture
- [ ] 4.5.8: Add expected RBS with type bounds to fixture
- [ ] 4.5.9: Write integration test for type bounds using new fixture
- [ ] 4.5.10: Run tests and verify they pass
- [ ] 4.5.11: Update implementation-status.md to mark type bounds as implemented
- [ ] 4.5.12: Update implementation-status.md to mark Phase 4 as complete

---

### Phase 5: Class/Module Features (Priority: MEDIUM)

**Goal**: Support inheritance, mixins, and other class-level features.

#### 5.1 Inheritance (Parsing)

- [ ] 5.1.1: Add `super_class` attribute to ClassNode class
- [ ] 5.1.2: Update ClassNode#initialize to accept `super_class:` parameter (default: nil)
- [ ] 5.1.3: Update ClassNode unit test to verify super_class attribute
- [ ] 5.1.4: Update ClassNode.from_decls to extract parent class from RBS declaration
- [ ] 5.1.5: Write unit test: ClassNode.from_decls parses inheritance relationship
- [ ] 5.1.6: Implement parent class extraction in ClassNode.from_decls
- [ ] 5.1.7: Run tests and verify they pass

#### 5.2 Inheritance (Comparison and Fixtures)

- [ ] 5.2.1: Update ClassNode#pretty_print to show parent class
- [ ] 5.2.2: Write unit test: ClassNode with matching parent class
- [ ] 5.2.3: Write unit test: ClassNode with mismatched parent class
- [ ] 5.2.4: Update bird fixture to test inheritance comparison
- [ ] 5.2.5: Write integration test for inheritance using bird fixture
- [ ] 5.2.6: Run tests and verify they pass
- [ ] 5.2.7: Update implementation-status.md to mark inheritance as implemented

#### 5.3 Module Mixins (include)

- [ ] 5.3.1: Add `includes` attribute (Array) to ClassNode class
- [ ] 5.3.2: Update ClassNode#initialize to accept `includes:` parameter (default: [])
- [ ] 5.3.3: Update ClassNode unit test to verify includes attribute
- [ ] 5.3.4: Update ClassNode.from_decls to extract included modules from RBS
- [ ] 5.3.5: Write unit test: ClassNode.from_decls parses include statements
- [ ] 5.3.6: Implement include extraction in ClassNode.from_decls
- [ ] 5.3.7: Run tests and verify they pass

#### 5.4 Module Mixins (extend, prepend)

- [ ] 5.4.1: Add `extends` and `prepends` attributes (Arrays) to ClassNode class
- [ ] 5.4.2: Update ClassNode#initialize to accept `extends:` and `prepends:` parameters
- [ ] 5.4.3: Update ClassNode unit test to verify extends and prepends attributes
- [ ] 5.4.4: Update ClassNode.from_decls to extract extend and prepend statements
- [ ] 5.4.5: Write unit test: ClassNode.from_decls parses extend and prepend statements
- [ ] 5.4.6: Implement extend and prepend extraction
- [ ] 5.4.7: Update ClassNode#pretty_print to show mixins
- [ ] 5.4.8: Create fixture: spec/fixtures/examples/module_inclusion/
- [ ] 5.4.9: Add Ruby code with module mixins to fixture
- [ ] 5.4.10: Add expected RBS with include/extend/prepend to fixture
- [ ] 5.4.11: Write integration test for module mixins using new fixture
- [ ] 5.4.12: Run tests and verify they pass
- [ ] 5.4.13: Update implementation-status.md to mark module mixins as implemented

#### 5.5 Attributes (attr_reader)

- [ ] 5.5.1: Research RBS::AST::Members::AttrReader structure
- [ ] 5.5.2: Update ClassNode.from_decls to detect attr_reader members
- [ ] 5.5.3: Convert attr_reader to equivalent getter MethodNode
- [ ] 5.5.4: Write unit test: ClassNode.from_decls converts attr_reader to method
- [ ] 5.5.5: Implement attr_reader conversion
- [ ] 5.5.6: Run tests and verify they pass

#### 5.6 Attributes (attr_writer, attr_accessor)

- [ ] 5.6.1: Research RBS::AST::Members::AttrWriter and AttrAccessor structures
- [ ] 5.6.2: Update ClassNode.from_decls to detect attr_writer and attr_accessor
- [ ] 5.6.3: Convert attr_writer to equivalent setter MethodNode
- [ ] 5.6.4: Convert attr_accessor to getter and setter MethodNodes
- [ ] 5.6.5: Write unit test: ClassNode.from_decls converts attr_writer correctly
- [ ] 5.6.6: Write unit test: ClassNode.from_decls converts attr_accessor correctly
- [ ] 5.6.7: Implement attr_writer and attr_accessor conversion
- [ ] 5.6.8: Create fixture: spec/fixtures/examples/attributes/
- [ ] 5.6.9: Add Ruby code with attributes to fixture
- [ ] 5.6.10: Add expected RBS with attr_reader/writer/accessor to fixture
- [ ] 5.6.11: Write integration test for attributes using new fixture
- [ ] 5.6.12: Run tests and verify they pass
- [ ] 5.6.13: Update implementation-status.md to mark attributes as implemented

#### 5.7 Class Instance Variables

- [ ] 5.7.1: Update InstanceVariableNode to add `scope` attribute (:instance or :class)
- [ ] 5.7.2: Update InstanceVariableNode#initialize to accept `scope:` parameter
- [ ] 5.7.3: Update InstanceVariableNode unit test to verify scope attribute
- [ ] 5.7.4: Update InstanceVariableNode.from_ast to detect self.@var syntax
- [ ] 5.7.5: Write unit test: InstanceVariableNode.from_ast handles class instance variables
- [ ] 5.7.6: Implement class instance variable detection
- [ ] 5.7.7: Update InstanceVariableNode#pretty_print to show scope
- [ ] 5.7.8: Create fixture: spec/fixtures/examples/class_instance_vars/
- [ ] 5.7.9: Add Ruby code with class instance variables to fixture
- [ ] 5.7.10: Add expected RBS with self.@var syntax to fixture
- [ ] 5.7.11: Write integration test for class instance variables using new fixture
- [ ] 5.7.12: Run tests and verify they pass
- [ ] 5.7.13: Update implementation-status.md to mark class instance variables as implemented

#### 5.8 Class Variables

- [ ] 5.8.1: Create ClassVariableNode class (similar to InstanceVariableNode)
- [ ] 5.8.2: Add ClassVariableNode#initialize with name and type
- [ ] 5.8.3: Add ClassVariableNode#count_leaf and #count_matches methods
- [ ] 5.8.4: Add ClassVariableNode#pretty_print method
- [ ] 5.8.5: Write unit tests for ClassVariableNode
- [ ] 5.8.6: Add `class_variable_nodes` attribute to ClassNode
- [ ] 5.8.7: Update ClassNode#initialize to accept class_variable_nodes parameter
- [ ] 5.8.8: Update ClassNode.from_decls to extract class variables
- [ ] 5.8.9: Write unit test: ClassNode.from_decls parses class variables
- [ ] 5.8.10: Implement class variable extraction
- [ ] 5.8.11: Update ClassNode#count_leaf to include class variables
- [ ] 5.8.12: Update ClassNode#count_matches to include class variables
- [ ] 5.8.13: Update ClassNode#pretty_print to show class variables
- [ ] 5.8.14: Create fixture: spec/fixtures/examples/class_variables/
- [ ] 5.8.15: Add Ruby code with class variables to fixture
- [ ] 5.8.16: Add expected RBS with @@var syntax to fixture
- [ ] 5.8.17: Write integration test for class variables using new fixture
- [ ] 5.8.18: Run tests and verify they pass
- [ ] 5.8.19: Update implementation-status.md to mark class variables as implemented
- [ ] 5.8.20: Update implementation-status.md to mark Phase 5 as complete

---

### Phase 6: Advanced RBS Features (Priority: LOW)

**Goal**: Support remaining RBS features for completeness.

#### 6.1 Interfaces (Parsing)

- [ ] 6.1.1: Create InterfaceNode class (similar to ClassNode)
- [ ] 6.1.2: Add InterfaceNode#initialize with typename and method_nodes
- [ ] 6.1.3: Add InterfaceNode#count_leaf and #count_matches methods
- [ ] 6.1.4: Add InterfaceNode#pretty_print method
- [ ] 6.1.5: Write unit tests for InterfaceNode
- [ ] 6.1.6: Update Environment.from_path to load interface declarations
- [ ] 6.1.7: Write unit test: Environment.from_path loads interfaces
- [ ] 6.1.8: Implement interface loading in Environment
- [ ] 6.1.9: Run tests and verify they pass

#### 6.2 Interfaces (Comparison and Fixtures)

- [ ] 6.2.1: Update ComparisonTree.from_envs to handle interfaces
- [ ] 6.2.2: Add `interface_nodes` attribute to ComparisonTree
- [ ] 6.2.3: Update ComparisonTree#count_leaf to include interfaces
- [ ] 6.2.4: Update ComparisonTree#count_matches to include interfaces
- [ ] 6.2.5: Update ComparisonTree#pretty_print to show interfaces
- [ ] 6.2.6: Create fixture: spec/fixtures/examples/interfaces/
- [ ] 6.2.7: Add Ruby code implementing interfaces to fixture
- [ ] 6.2.8: Add expected RBS with interface definitions to fixture
- [ ] 6.2.9: Write integration test for interfaces using new fixture
- [ ] 6.2.10: Run tests and verify they pass
- [ ] 6.2.11: Update implementation-status.md to mark interfaces as implemented

#### 6.3 Type Aliases (Loading)

- [ ] 6.3.1: Update Environment.from_path to load type alias declarations
- [ ] 6.3.2: Add `type_aliases` attribute to Environment class
- [ ] 6.3.3: Write unit test: Environment.from_path loads type aliases
- [ ] 6.3.4: Implement type alias loading
- [ ] 6.3.5: Run tests and verify they pass

#### 6.4 Type Aliases (Resolution)

- [ ] 6.4.1: Add type alias resolution method to Environment class
- [ ] 6.4.2: Write unit test: Type aliases are resolved during comparison
- [ ] 6.4.3: Update TypeNode#matches? to resolve type aliases before comparison
- [ ] 6.4.4: Handle recursive type aliases with cycle detection
- [ ] 6.4.5: Write unit test: Recursive type aliases are handled correctly
- [ ] 6.4.6: Create fixture: spec/fixtures/examples/type_aliases/
- [ ] 6.4.7: Add Ruby code using type aliases to fixture
- [ ] 6.4.8: Add expected RBS with type alias definitions to fixture
- [ ] 6.4.9: Write integration test for type aliases using new fixture
- [ ] 6.4.10: Run tests and verify they pass
- [ ] 6.4.11: Update implementation-status.md to mark type aliases as implemented

#### 6.5 Method Overloading

- [ ] 6.5.1: Update MethodNode to store multiple overloads (Array of signatures)
- [ ] 6.5.2: Update MethodNode#initialize to accept overloads parameter
- [ ] 6.5.3: Update MethodNode.from_ast to extract all method overloads
- [ ] 6.5.4: Write unit test: MethodNode.from_ast handles method overloading
- [ ] 6.5.5: Implement overload extraction
- [ ] 6.5.6: Update MethodNode#count_leaf to sum across all overloads
- [ ] 6.5.7: Update MethodNode#count_matches to handle overload matching
- [ ] 6.5.8: Implement overload matching logic (best match or all matches)
- [ ] 6.5.9: Update MethodNode#pretty_print to show all overloads
- [ ] 6.5.10: Create fixture: spec/fixtures/examples/method_overloading/
- [ ] 6.5.11: Add Ruby code with overloaded methods to fixture
- [ ] 6.5.12: Add expected RBS with method overloads to fixture
- [ ] 6.5.13: Write integration test for method overloading using new fixture
- [ ] 6.5.14: Run tests and verify they pass
- [ ] 6.5.15: Update implementation-status.md to mark method overloading as implemented

#### 6.6 Proc Types

- [ ] 6.6.1: Research RBS::Types::Proc structure
- [ ] 6.6.2: Update TypeNode#type_to_string to handle Proc types
- [ ] 6.6.3: Write unit test: TypeNode#type_to_string formats proc types correctly
- [ ] 6.6.4: Implement proc type formatting
- [ ] 6.6.5: Write unit test: TypeNode#matches? compares proc signatures
- [ ] 6.6.6: Implement proc type comparison (parameters and return type)
- [ ] 6.6.7: Write unit test: TypeNode#matches? handles self-type binding in procs
- [ ] 6.6.8: Implement self-type binding comparison
- [ ] 6.6.9: Create fixture: spec/fixtures/examples/proc_types/
- [ ] 6.6.10: Add Ruby code with proc types to fixture
- [ ] 6.6.11: Add expected RBS with proc signatures to fixture
- [ ] 6.6.12: Write integration test for proc types using new fixture
- [ ] 6.6.13: Run tests and verify they pass
- [ ] 6.6.14: Update implementation-status.md to mark proc types as implemented

#### 6.7 Constants

- [ ] 6.7.1: Create ConstantNode class
- [ ] 6.7.2: Add ConstantNode#initialize with name and type
- [ ] 6.7.3: Add ConstantNode#count_leaf and #count_matches methods
- [ ] 6.7.4: Add ConstantNode#pretty_print method
- [ ] 6.7.5: Write unit tests for ConstantNode
- [ ] 6.7.6: Add `constant_nodes` attribute to ClassNode
- [ ] 6.7.7: Update ClassNode.from_decls to extract constants
- [ ] 6.7.8: Write unit test: ClassNode.from_decls parses constants
- [ ] 6.7.9: Implement constant extraction
- [ ] 6.7.10: Update ClassNode#count_leaf to include constants
- [ ] 6.7.11: Update ClassNode#count_matches to include constants
- [ ] 6.7.12: Update ClassNode#pretty_print to show constants
- [ ] 6.7.13: Run tests and verify they pass

#### 6.8 Global Variables

- [ ] 6.8.1: Create GlobalVariableNode class
- [ ] 6.8.2: Add GlobalVariableNode#initialize with name and type
- [ ] 6.8.3: Add GlobalVariableNode#count_leaf and #count_matches methods
- [ ] 6.8.4: Add GlobalVariableNode#pretty_print method
- [ ] 6.8.5: Write unit tests for GlobalVariableNode
- [ ] 6.8.6: Update Environment.from_path to load global variable declarations
- [ ] 6.8.7: Add `global_variable_nodes` attribute to ComparisonTree
- [ ] 6.8.8: Update ComparisonTree.from_envs to compare global variables
- [ ] 6.8.9: Update ComparisonTree#count_leaf to include global variables
- [ ] 6.8.10: Update ComparisonTree#count_matches to include global variables
- [ ] 6.8.11: Create fixture: spec/fixtures/examples/constants/
- [ ] 6.8.12: Add Ruby code with constants and globals to fixture
- [ ] 6.8.13: Add expected RBS with constant and global definitions to fixture
- [ ] 6.8.14: Write integration test for constants/globals using new fixture
- [ ] 6.8.15: Run tests and verify they pass
- [ ] 6.8.16: Update implementation-status.md to mark constants and globals as implemented

#### 6.9 Visibility Modifiers

- [ ] 6.9.1: Add `visibility` attribute to MethodNode (:public, :private, :protected)
- [ ] 6.9.2: Update MethodNode#initialize to accept visibility parameter (default: :public)
- [ ] 6.9.3: Update MethodNode unit test to verify visibility attribute
- [ ] 6.9.4: Update MethodNode.from_ast to extract visibility from RBS
- [ ] 6.9.5: Write unit test: MethodNode.from_ast detects visibility modifiers
- [ ] 6.9.6: Implement visibility extraction
- [ ] 6.9.7: Update MethodNode#pretty_print to show visibility
- [ ] 6.9.8: Create fixture: spec/fixtures/examples/visibility/
- [ ] 6.9.9: Add Ruby code with visibility modifiers to fixture
- [ ] 6.9.10: Add expected RBS with visibility modifiers to fixture
- [ ] 6.9.11: Write integration test for visibility using new fixture
- [ ] 6.9.12: Run tests and verify they pass
- [ ] 6.9.13: Update implementation-status.md to mark visibility as implemented
- [ ] 6.9.14: Update implementation-status.md to mark Phase 6 as complete

---

### Phase 7: Real-World Benchmarking (Priority: LOW)

**Goal**: Support benchmarking with real-world codebases.

#### 7.1 Reporting Infrastructure

- [ ] 7.1.1: Create Reporter class in lib/type_eval_rb/reporter.rb
- [ ] 7.1.2: Add Reporter#initialize accepting ComparisonTree
- [ ] 7.1.3: Add Reporter#summary method to output basic statistics
- [ ] 7.1.4: Write unit test: Reporter#summary shows count_leaf, count_matches, accuracy
- [ ] 7.1.5: Implement summary reporting
- [ ] 7.1.6: Add Reporter#detailed_mismatches method
- [ ] 7.1.7: Write unit test: Reporter#detailed_mismatches lists all type mismatches
- [ ] 7.1.8: Implement detailed mismatch reporting
- [ ] 7.1.9: Run tests and verify they pass

#### 7.2 JSON Output Format

- [ ] 7.2.1: Add Reporter#to_json method
- [ ] 7.2.2: Write unit test: Reporter#to_json outputs valid JSON with metrics
- [ ] 7.2.3: Implement JSON serialization of comparison results
- [ ] 7.2.4: Write unit test: Reporter#to_json includes mismatch details
- [ ] 7.2.5: Add mismatch details to JSON output
- [ ] 7.2.6: Run tests and verify they pass

#### 7.3 Standard Library Fixtures (Array)

- [ ] 7.3.1: Create fixture: spec/fixtures/stdlib/array/
- [ ] 7.3.2: Extract subset of Array RBS signature from Ruby core
- [ ] 7.3.3: Add expected Array signature to fixture
- [ ] 7.3.4: Create sample actual (inferred) signature with intentional differences
- [ ] 7.3.5: Write benchmark test for Array comparison
- [ ] 7.3.6: Run test and document accuracy metrics

#### 7.4 Standard Library Fixtures (Hash, String)

- [ ] 7.4.1: Create fixture: spec/fixtures/stdlib/hash/
- [ ] 7.4.2: Extract subset of Hash RBS signature
- [ ] 7.4.3: Add expected and actual signatures to fixture
- [ ] 7.4.4: Write benchmark test for Hash
- [ ] 7.4.5: Create fixture: spec/fixtures/stdlib/string/
- [ ] 7.4.6: Extract subset of String RBS signature
- [ ] 7.4.7: Add expected and actual signatures to fixture
- [ ] 7.4.8: Write benchmark test for String
- [ ] 7.4.9: Run tests and document metrics

#### 7.5 Benchmark Documentation

- [ ] 7.5.1: Create doc file: docs/benchmarking-guide.md
- [ ] 7.5.2: Document how to run benchmarks
- [ ] 7.5.3: Document how to add new benchmark fixtures
- [ ] 7.5.4: Document how to interpret results
- [ ] 7.5.5: Add example benchmark results
- [ ] 7.5.6: Update CLAUDE.md to reference benchmarking guide
- [ ] 7.5.7: Update implementation-status.md to mark Phase 7 as complete

---

## Progress Tracking

- **Current Phase**: Phase 1 (Core Type Comparison)
- **Next Task**: 1.1.1 - Add `matches?` method skeleton to TypeNode class
- **Completed Tasks**: 0 / 350+

## Completion Checklist

After completing all phases:

- [ ] All unit tests passing
- [ ] All integration tests passing
- [ ] Test coverage >90%
- [ ] All documentation updated
- [ ] implementation-status.md reflects 100% completion
- [ ] README updated with usage examples
- [ ] CHANGELOG updated
- [ ] Version bumped for release
