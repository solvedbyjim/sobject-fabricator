# sobject-fabricator

`sobject-fabricator` is an implementation package for the `SObjectBuilder` interface defined in the base `sobject-builder` package.

This package is not intended to be used directly as the primary entry point. Instead, it is installed alongside the base package and resolved as the active implementation when it is configured as the default implementation in the org.

## Relationship to the base package

The base package owns the public contract and implementation resolution. This package contributes:

- the implementation class: `SObjectFabricatorAdaptor`
- a custom metadata registration record: `SObject_Builder_Implementation.SObject_Fabricator`

Once the package is installed and that implementation record is marked as default, calls made through the `SObjectBuilder` interface from the base package will resolve to this implementation.

Base package repository:

- https://github.com/solvedbyjim/sobject-builder

## What this package provides

`SObjectFabricatorAdaptor` implements the builder contract and delegates to the fabricator classes in this package to support:

- building from an `SObject`, object API name, or Apex `Type`
- setting individual fields or field maps
- setting parent relationships
- setting or appending child relationships
- materializing the result back to an `SObject`

## Installation and activation

1. Install the base `sobject-builder` package.
2. Install this `sobject-fabricator` package.
3. In the subscriber org, mark the `SObject Fabricator` implementation record as the default implementation.

This package currently ships its registration record with `Default__c = false`, so it must be explicitly activated before the base package will resolve to it by default.

## Usage

Use the APIs documented by the base `sobject-builder` package to request or work with an `SObjectBuilder`.

After this package is installed and marked as the default implementation, those interface-based calls will use `SObjectFabricatorAdaptor` behind the scenes. Consumers should generally depend on the base package contract rather than referencing this implementation package directly.

## Repository scope

This repository contains the fabricator implementation and its tests. Interface-level documentation, contracts, and implementation-selection behavior belong to the base package.
