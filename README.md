__Validation Kit__ · [Validation Components][validation-components]

[validation-kit]: https://github.com/nsagora/validation-kit
[validation-components]: https://github.com/nsagora/validation-components 

-------

# Validation Kit

[![travis-status]][travis-overview] [![codecov-status]][codecov-overview] [![carthage-compatible]][carthage-overview] [![license]][license-overview] [![twitter]][twitter-overview]

[license]: https://img.shields.io/badge/license-Apache%20License%202.0-blue.svg?style=flat
[license-overview]: http://choosealicense.com/licenses/apache-2.0/

[twitter]: https://img.shields.io/badge/twitter-%40nsgaora-blue.svg?style=flat
[twitter-overview]: https://twitter.com/nsagora

[travis-status]: https://travis-ci.org/nsagora/validation-kit.svg?branch=develop
[travis-overview]: https://travis-ci.org/nsagora/validation-kit

[codecov-status]: https://codecov.io/gh/nsagora/validation-kit/branch/develop/graph/badge.svg
[codecov-overview]: https://codecov.io/gh/nsagora/validation-kit 

[carthage-compatible]: https://img.shields.io/badge/carthage-compatible-4BC51D.svg?style=flat
[carthage-overview]: https://github.com/Carthage/Carthage

## Introduction

`Validation Kit` is designed to be a lightweight framework specialised in user data validation, such as email format, input length or passwords matching.

At the core of this project are the following principles:

- Separation of concerns
- Availability on all platforms 
- Open to extensibility

### Separation of concerns

Think of `Validation Kit` as to an adjustable wrench more than to a Swiss knife. 
With this idea in mind, the kit is composed from a small set of protocols, classes and structs than ca be easily used to fit your project needs.

### All platforms availability

Since validation can take place at many levels, Validation Kit was designed to support iOS, macOS, tvOS, watchOS and native swift projects, such as server apps.

### Open to extensibility

Every project is uniq in it's challenges and it's great when we can focus on solving them instead on focusing on boiler plate tasks. 
While Validation Kit is compact and offers all you need to build validation around your project needs, we created `Validation Components` to extends it by adding the common validations that most of the projects can benefits of.
This includes validation predicates for email, required fields, password matching, url and many other.     

## Installation

### Carthage

The full documentation on how to install and use [Carthage][carthage] is available on their official github [page][carthage].

To use the latest stable version, add this to your [`Cartfile`][carthage-cartfile]:

``` 
github "nsagora/validation-kit" 
```

To use a certain version, add this to your [`Cartfile`][carthage-cartfile]:

``` 
github "nsagora/validation-kit" >= 0.1.0 
```

To use the latest version in development, add this to your [`Cartfile`][carthage-cartfile]:

``` 
github "nsagora/validation-kit" "develop" 
```

[carthage]: https://github.com/Carthage/Carthage
[carthage-cartfile]: https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile

## Concepts

### ValidationPredicate

The `ValidationPredicate` represents the core `protocol` and has the role to `evaluate` if an input matches on a given predicate.

Out of the box, `ValidationKit` brings the following predicates, which allow the developers to construct their specific predicates:
- `RegexValidationPredicate`
- `BlockValidationPredicate`

For more advanced or complex predicates the developers can extend the `ValidationPredicate` to fit the project needs.

### ValidationConstraint

A `ValidationConstraint` represents a structure that link a `ValidationPredicate` with a custom message, useful for user feedback.

### Validator

A `Validator` represents a collection of constraints and allows the evaluation to be made on:
- any of the constraints
- all constraints

To provide context, a `Validator` allows to constrain an input as being required and as being a valid email.

## Credits and references

The project was been inspired from other open source projects and they worth to be mentioned below for reference:

- https://github.com/adamwaite/Validator
- https://github.com/jpotts18/SwiftValidator