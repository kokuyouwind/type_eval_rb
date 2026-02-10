# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

TypeEvalRb is a micro-benchmarking framework for Ruby type inference tools. It compares expected RBS type signatures against actual inferred types using a tree-based comparison structure.

## Development Commands

**Run tests:**
```bash
mise exec -- bundle exec rake spec
```

**Run linter:**
```bash
mise exec -- bundle exec rake rubocop
```

**Run all checks (default):**
```bash
mise exec -- bundle exec rake
```

**Interactive console:**
```bash
mise exec -- bin/console
```

**Note:** This project uses `mise` for Ruby version management. Always prefix commands with `mise exec --` to ensure the correct Ruby version (3.3.1).

## Architecture

The framework consists of two main components:

### Environment (`lib/type_eval_rb/environment.rb`)
Loads and parses RBS files from a given path using the RBS library. Creates an environment containing class declarations extracted from `.rbs` files.

Key method: `Environment.from_path(path)` - Loads RBS files from `path/sig/*.rbs` and returns an Environment with filtered class declarations.

### ComparisonTree (`lib/type_eval_rb/comparison_tree.rb`)
Hierarchical tree structure for comparing expected vs actual type signatures. Created via `ComparisonTree.from_envs(expected:, actual:)`.

**Node hierarchy:**
- `ClassNode` - Compares class-level types
  - `InstanceVariableNode` - Compares instance variable types
  - `MethodNode` - Compares method signatures
    - `ArgumentNode` - Compares parameter types
    - `TypeNode` - Compares individual type annotations (return types, parameter types)

Each node stores both `expected` and `actual` AST objects from RBS for detailed comparison.

## Test Fixtures

Example RBS signatures and Ruby code are located in `spec/fixtures/examples/`. Each example contains:
- `lib/*.rb` - Ruby source code
- `sig/*.rbs` - Expected or actual type signatures

These fixtures are used to test the comparison functionality.

## RuboCop Configuration

- RSpec and Rake cops enabled
- Ruby 3.3 target
- Custom metrics limits (ABC: 20, MethodLength: 15)
- Excludes `spec/fixtures/` from linting

## Documentation

Detailed documentation is available in `.claude/docs/`:

- **[Implementation Status](.claude/docs/implementation-status.md)** - Current implementation status, missing features, and implementation priorities
- **[RBS Specification](.claude/docs/rbs-specification.md)** - Overview of RBS syntax features that TypeEvalRb needs to support
- **[Testing Strategy](.claude/docs/testing-strategy.md)** - Testing approach, fixture organization, and test development workflow
- **[Development Roadmap](.claude/docs/roadmap.md)** - Phased development plan with tasks and acceptance criteria

### Key Insights

**Current State**: The framework has basic tree structure in place but is missing core comparison logic and metrics calculation.

**Immediate Priorities**:
1. Implement type comparison logic in `TypeNode`
2. Implement `count_leaf` and `count_matches` in all nodes
3. Add union type support
4. Support optional and keyword parameters

**Testing**: Each new feature should include unit tests, integration tests, and corresponding fixtures in `spec/fixtures/examples/`.
