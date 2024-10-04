---
aliases: 
tags:
  - fp
  - data
  - scala
date: 2050-09-30T19:36:43+00:00
lastmod: 2024-10-01T19:48:29+00:00
title: Persistent Data Structures
---
When I first heard the term "Persistent Data Structure" I had no clue what it meant. I started using them, and after a while, I want to use them almost everywhere instead of non-persistent data structures. Here I'd like to supply a short introduction of the concept and its benefit.

### Ephemeral Data Structure
A data structure is how a set of data is stored and how we can interact with it. In `Java` we commonly use ArrayLists and Sets for example. These types provide you with ways to organize your data and optimize for your specific use case. They are *ephemeral* as it's previous state is not retained after operations on the data structure. This means that when using these mutable collections, we need to be careful not to share them. If we share a mutable collections, they can be updated without our notice, possibly causing hard to trace bugs and unpredictable behaviour.
If we want to prevent this possibility when sharing mutable collections, we need to do a lot of work to keep our programs consistent. This is *accidental complexity*. We create defensive copies or add safety guards to keep the mutation of our data structure under control.

### Immutability
In many situations it is easier to use a data structure that is immutable, meaning it's structure cannot be altered after initialisation. The certainty that the data structure remains intact means that we can freely share it in our code, unafraid of mutations, race conditions or bugs. In functional languages such as Haskell and Scala, collections are immutable by default, which may sound very limiting. What if we need to make some modifications?

### Modifications
When requesting a modification on an immutable data structure, we don't actually modify the original structure. Instead we are given a new reference, and old references will remain valid.
For example, we can create a list of data, assign it to a variable, and prepend an element:

```scala
scala> val original = List(1,2,3)
val original: List[Int] = List(1, 2, 3)

scala> val updated = original.prepended(0)
val updated: List[Int] = List(0, 1, 2, 3)

scala> original
val res2: List[Int] = List(1, 2, 3)
```

The `updated` list contains the new element, while the `original` list is still a valid reference to the unchanged data. No matter what operations we perform on it, `original` will stay a valid reference.
For the programmer, this means a lot of defensive code does not have to be written, and entire categories of errors can be made impossible by design. Not only is it more bug-proof, it is also a lot simpler, meaning code is more maintainable.

### Performance
Intuitively it may seem that using immutable data like this creates a lot of extra work and may incur a performance hit. But this does not have to be the case, and it may even perform better than alternate scenarios where we would have to make defensive copies.

When we peek under the hood of the operation for appending an element, we see that no additional list is created at all, and no data is copied over. Instead, the `updated` instances just contains a head node and a reference to the `original`.

TODO image here showing it

This shows how `prepend` is implemented and optimised for performance. Some of the other operations have more complicated implementations to enable fast execution.

### Wrapping up
Your data-processing code can be expressive and focused on what you want to achieve instead of error-prone guards and defensive copies. Think your operations will perform faster in parallel? Try it out - running into a `ConcurrentModificationException` is a thing of the past. I highly recommend using persistent data structures to improve your developer experience.

I recommend [this presentation](https://www.youtube.com/watch?v=pNhBQJN44YQ&t=11s) by [Daniel Spiewak](https://github.com/djspiewak) for a great illustration of how a singly linked list achieves excellent performance.