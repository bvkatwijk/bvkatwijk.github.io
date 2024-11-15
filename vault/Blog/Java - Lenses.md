---
aliases: 
tags:
  - fp
  - java
  - data
  - api
date: 2024-10-26T18:26:22+00:00
lastmod: 2024-11-15T15:52:50+00:00
title: Lenses
GHissueID: "13"
featured_image: /images/lens.webp
---

### Immutability
Using immutable types has a number of benefits. Since it eliminates mutation, it makes code easier to reason about. Also, it eliminates concurrent modification problems, thereby unlocking a lot of performance improvement opportunities. Java originally was fully Object-Oriented but it adapted to other paradigms. The language itself still lacks some features that makes it convenient to work with immutable data. In this post I'd like to show what can currently be done in vanilla Java and show a powerful concept to transform immutable data.

### Java Records
Since Java 16, `record` classes were finalised and added to the language, which are described in [JEP 395](https://openjdk.org/jeps/395) as  "transparent carriers for immutable data". The canonical example of this is a `Point` in two-dimensional space. A `Point` is defined by an `x` and `y` coordinate - nothing more, nothing less. 

```java
record Point(int x, int y) { }
```

Using a `record` gives us a lot of functionality out of the box like proper `equals`/`hashcode` implementations, constructors, accessor methods, and more. The type is shallowly immutable, meaning that there is no way to reassign its components. This restriction gives us a lot of benefits - we can safely distribute instances to different parts of our logic and safely use concurrent programming without fear, since there is no way to mutate the instance itself.

### Data Transformation
There are of course plenty of situations where we do need data deviating from the data that we received. For example, updating the `x` value of a given `Point` . We do not mutate our input, but we create a new `Point`:

```java
record Point(int x, int y) {
	Point withX(int input) {
		return new Point(input, this.y());
	}
	
	Point withY(int input) {
		return new Point(this.x(), input);
	}
}
```

We successfully create a new instance, but we do have to specify the value for each component explicitly, even when it is the same as the input value. When our code grows in volume (more creation methods or more record components) this becomes tedious and error-prone.
### Derived Creation
To solve this we need a mechanism for *derived instance creation*, a way to specify that we want to create new instances with only some modifications. [JEP 468](https://openjdk.org/jeps/468) is exploring this as part of Project Amber.

One way to already get this functionality is to use Lombok `@With` annotation. It generates `with` methods for each record component, allowing derived creation altering only that component

```java
@With
record Point(int x, int y) {
	// withX, withY generated automatically
}
```

This enables convenient shallow derived creation for *single components*, a valuable step, but we can take it a lot further. What if we want to make deep transformations?

### Deep Transformation
As an example, suppose we have record classes for `Person` , `House`, `Address` and `City`. A `Person` has a `House`, which has an `Address`, which has a `City` as follows:

```java
@With record Person(String firstName, String lastName, House house) { }
@With record House(Address address) { }
@With record Address(String street, String zipCode, City city) { }
@With record City(String name) { }
```

Suppose `alice` wants to move to New York. Using the most convenient strategy discussed we end up with the following:

```java
static City NEW_YORK = new City("New York");

public static Person moveToNewYork(Person person) {
	return person.withHouse(
		person.house().withAddress(
			person.house().address().withCity(NEW_YORK)
		)
	);
}
```

In order to provide the new `City` for a `Person` we have to call `withHouse`, and specify explicitly that we would like to use the existing `house` with a transformation to `address`. Then we use the existing `address` but specify a new value for `city`. That was a lot of code to write, and we can see that this does not scale well when nesting grows deeper or when we have a lot of transformations that we would like to express.
### Lenses
What is needed here is an API to express the intent to apply nested transformations. In `Haskell` and `Scala` the paradigm of immutable programming has existed for a long time and thus support has emerged to effectively work with immutable data. One option is to use a  `Lens` paradigm. 

Before exploring what a `Lens` is and how it works, lets demonstrate the above example in a `Lens` style, expressing the intent to change the city of the address of the house of the person:

```java
static City NEW_YORK = new City("New York");

public static Person moveToNewYork(Person person) {
	return PersonLens.µ
		.house()
		.address()
		.city()
		.with(NEW_YORK)
		.apply(person);
}
```

This enables a fluent style where the implementation is declarative and non-repetitive. This eliminates scaling issues with record size, nesting level, or amount of transformations.

### Foundation
The design behind the above paradigm is called `Lensing`. A `Lens` is a type with two essential functionalities: *retrieving* nested data, and *transforming* it. This is implemented by adding these functionalities as components of a record class. The `Lens` "zooms into" a child property of type `T` of a parent type `S`:

```java
record Lens<S, T>(Function2<S, T, S> with, Function1<S, T> get)
```

### Creating a Lens
To create a `Lens` allowing us to change the `City` of an `Address` we write the following:
```java
Lens<Address, City> addressCityLens = new Lens<>(Address::withCity, Address::city);
```

Writing all this by hand sounds like effort, so...

### Automatic Lenses
I've [created a library](https://github.com/bvkatwijk/java-lens) to automate the above using annotation processing. All that is required is annotating the records that you want to use the Lens paradigm on.

```java
@With @Lenses record Person(String firstName, String lastName, House house) { }
@With @Lenses record House(Address address) { }
@With @Lenses record Address(String street, String zipCode, City city) { }
@With @Lenses record City(String name) { }
```

This will generate a helper class holding `Lens` instances that can be applied at will. To enable the method chain for nested lensing it also contains a `ROOT` instance.

The library is a work-in-progress. Feel free to try it out - I hope the examples (implemented as unit tests) serve both as documentation and a quick way to experiment. It is published on [Maven Central](https://mvnrepository.com/artifact/nl.bvkatwijk/java-lens) . Currently it is still necessary to also use Lombok's `@With` annotation, this requirement may be dropped in a future release.

### Inspiration
The implementation of this library was driven by inspiration from `Monocle`, a more powerful library for  `Scala` authored by [Julien Truffaut](https://github.com/julien-truffaut). Monocle mentions [Haskell Lens](https://github.com/ekmett/lens)  (authored by [Edward Kmett](https://github.com/ekmett) as its own main inspiration. I would like to express gratitude and admiration for their work.

--- 

## Appendix

### Lens Composition
An important property of `Lens` (driving its main power) is that you can compose them - meaning you can chain multiple lenses. We have showed how to create a `addressCityLens`, capable of transforming the `City` of an `Address`.

So a `Lens` of `Person` into `City` would be a chain `Person -> House -> Address -> City`:

```java
Lens<Person, City> personCityLens = PersonLens.House
	.andThen(HouseLens.Address)
	.andThen(AddressLens.City);
```

### Interface

To keep the implementation choice of a `Lens` record separated from the library API i've added an `ILens`  interface. Providing the two foundational functions, `get` and `with`, all other behaviour can be implemented. For example, I've added `get(S s)` and `with(S s, T t)` to be able to directly apply a lens onto an instance of `S`.

```java
public interface ILens<S, T> {  
    Function1<S, T> get();  
    Function2<S, T, S> with();  
  
    default T get(S s) {  
        return get().apply(s);  
    }  
  
    default S with(S subject, T value) {  
        return with().apply(subject, value);  
    }
}
```