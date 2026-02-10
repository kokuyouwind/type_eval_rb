# RBS Specification Overview

This document provides an overview of RBS (Ruby Signature) syntax that TypeEvalRb needs to support.

## Official Documentation Sources

- [RBS Syntax Documentation](https://github.com/ruby/rbs/blob/master/docs/syntax.md)
- [RBS By Example](https://github.com/ruby/rbs/blob/master/docs/rbs_by_example.md)
- [Writing Signatures Best Practices](https://github.com/ruby/rbs/wiki/Writing-Signatures-Best-Practices)
- [Main Repository](https://github.com/ruby/rbs)

## Type Syntax

### Basic Types

#### Class Instances
```rbs
Integer
::Integer
String
Hash[Symbol, String]
```

#### Interfaces
```rbs
_ToS
_Each[String]
::Enumerator::_Each[String]
```

#### Type Aliases
```rbs
name
list[Integer]
```

#### Singletons
```rbs
singleton(String)  # The String class itself
```

#### Literals
```rbs
123          # Integer literal
"hello"      # String literal
:symbol      # Symbol literal
true         # true literal
false        # false literal
```

### Composite Types

#### Union Types
```rbs
Integer | String
Integer | String | nil
```

#### Intersection Types
```rbs
_Reader & _Writer
```

#### Optional Types
```rbs
Integer?           # Equivalent to: Integer | nil
String?
```

#### Record Types
```rbs
{ id: Integer, name: String }
{ name: String, age: Integer? }
```

#### Tuple Types
```rbs
[]                     # Empty tuple
[String]               # Single element
[Integer, Integer]     # Pair
[String, Integer, bool]
```

### Special Types

#### Type System Types
```rbs
self          # Type of the receiver
instance      # Instance of the class
class         # The class itself
```

#### Boolean Type
```rbs
bool          # Alias for: true | false
```

#### Universal Types
```rbs
untyped       # Both subtype and supertype of all types
top           # Supertype of all types
bot           # Subtype of all types
```

#### Other Special Types
```rbs
nil           # nil type
void          # Return type for methods with no meaningful return value
```

### Proc Types

```rbs
^(Integer) -> String
^(?String, size: Integer) -> bool
^(Integer) [self: String] -> void     # With self-type binding
```

## Method Definitions

### Instance Methods

```rbs
def to_s: () -> String
def length: () -> Integer
```

### Singleton Methods

```rbs
def self.new: () -> Object
def self.create: (String) -> instance
```

### Module Functions

```rbs
def self?.sqrt: (Numeric) -> Numeric
```

### Method Overloading

```rbs
def +: (Float) -> Float
     | (Integer) -> Integer
     | (Numeric) -> Numeric
```

### Method Parameters

#### Required Positional Parameters
```rbs
def foo: (Integer, String) -> void
```

#### Optional Positional Parameters
```rbs
def foo: (?Integer size) -> void
def bar: (?Integer, ?String?) -> void
```

#### Rest Parameters
```rbs
def foo: (*Integer) -> void
def bar: (String, *Integer) -> void
```

#### Keyword Parameters
```rbs
def foo: (name: String) -> void                    # Required keyword
def bar: (?name: String) -> void                   # Optional keyword
def baz: (size: Integer sz, ?name: String) -> void # With labels
```

#### Keyword Rest Parameters
```rbs
def foo: (**String) -> void
```

#### Block Parameters
```rbs
def each: () { (String) -> void } -> void
def map: [U] () { (String) -> U } -> Array[U]
```

### Method Visibility

```rbs
private def puts: (*untyped) -> void
public def self.puts: (*untyped) -> void
protected def internal: () -> void
```

## Class/Module/Interface Declarations

### Class Declarations

#### Basic Class
```rbs
class Stack
  def push: (String) -> void
  def pop: () -> String
end
```

#### Generic Class
```rbs
class Stack[T]
  def push: (T) -> void
  def pop: () -> T
end
```

#### Inheritance
```rbs
class Child < Parent
end

class StringStack < Stack[String]
end
```

### Module Declarations

```rbs
module Enumerable[A, B] : _Each[A, B]
  def count: () -> Integer
end
```

### Interface Declarations

```rbs
interface _Hashing
  def hash: () -> Integer
  def eql?: (untyped) -> bool
end
```

### Aliases

```rbs
class Bar = Array
module Foo = Kernel
```

## Class/Module Members

### Instance Variables

```rbs
@name: String
@value: Integer?
self.@class_ivar: Hash[Symbol, String]  # Class instance variable
```

### Class Variables

```rbs
@@instances: Array[instance]
```

### Attributes

```rbs
attr_reader id: Integer
attr_writer name: String
attr_accessor email: String

# With custom names
attr_writer name (@raw_name): String

# With method types
attr_accessor people (): Array[Person]
```

### Mixins

```rbs
include Enumerable[String, void]
extend ActiveSupport::Concern
prepend Decorator
```

### Alias Methods

```rbs
alias collect map
alias self.new self.create
```

### Constants

```rbs
VERSION: String
DEFAULT_SIZE: Integer
```

## Generics & Type Parameters

### Variance

```rbs
class Array[out T]                    # Covariant
class Contravariant[in T]             # Contravariant
class Invariant[T]                    # Invariant (default)
class Array[unchecked out T]          # Skip variance validation
```

### Bounds

```rbs
class Box[T < Comparable]             # Upper bound
class Container[T > Numeric]          # Lower bound
class Flexible[T > Integer < Numeric] # Both bounds
```

### Default Type Parameters

```rbs
interface _Foo[T = untyped]
class Container[T = String]
```

## Type Aliases

```rbs
type subject = Attendee | Speaker
type list[out T] = [T, list[T]] | nil
type json = Integer | String | bool | Hash[String, json] | Array[json]
```

## Constants & Global Variables

```rbs
Person::DefaultEmail: String
SOME_CONSTANT: Integer

$LOAD_PATH: Array[String]
$stderr: IO
```

## Directives

### Use Directive

```rbs
use RBS::Namespace
use RBS::TypeName as TN
use RBS::AST::*
```

## Annotations

```rbs
%a{ metadata }
%a( metadata )
%a[ metadata ]
%a| metadata |
%a< metadata >
```

## Visibility Defaults

```rbs
public

def foo: () -> void
def bar: () -> void

private

def baz: () -> void
def qux: () -> void
```

## Implementation Considerations for TypeEvalRb

### Phase 1: Basic Support
- Class instances (with and without generics)
- Instance methods with basic parameters
- Instance variables
- Basic types (Integer, String, etc.)

### Phase 2: Type System
- Union types
- Optional types
- Tuple types
- Record types
- Intersection types

### Phase 3: Advanced Method Signatures
- Optional parameters
- Keyword parameters
- Rest parameters
- Block parameters
- Method overloading

### Phase 4: Advanced Class Features
- Generic type parameters with variance
- Type bounds
- Module mixins
- Attributes
- Singleton methods

### Phase 5: Additional Features
- Interfaces
- Type aliases
- Constants and global variables
- Proc types
- Special types (self, instance, class, etc.)
