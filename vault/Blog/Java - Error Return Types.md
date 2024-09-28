---
aliases: 
tags:
  - java
  - api
  - dx
  - fp
title: Java - Error Return Types
date: 2030-09-18T13:33:23+00:00
lastmod: 2024-09-28T11:01:33+00:00
GHissueID: "5"
---
Writing code assuming everything will follow the happy path may not result in the best software quality or user experience. Sometimes we choose to ignore unhappy paths, or lack awareness of the existence of unhappy paths. Both of these scenarios can lead to runtime bugs and problems for customers which may be good to prevent.

Many strategies and coding styles exist in different languages to give the developer tools to address this issue. In this post I'd like to explore some of them and illustrate my preferences.

To illustrate this I'll use a very minimal example where we design a `Baker` capable of creating `Pizza`. I'll be using an `interface` here for the Baker since the actual implementation is not relevant.

```java
record Pizza() { }
interface Baker {  
    <?> createPizza() <?>;  
}
```

We will be deciding on the signature of a `createPizza` method. Our `Baker` sometimes runs out of ingredients, making it impossible to produce a `Pizza`. However, our API does not reveal this fact. We can choose how we are going to express the possible paths of failure, and listed below are some common options. I frequently encounter solutions that results in poor handling and developer ergonomics. I have sorted them by my preference when it comes to handling domain errors, from worst to best.

### Nullable
```java
interface Baker {  
    Pizza createPizza();  
}
```

Returning `null` may be the worst option available. It does not express the possibility of failure in any way, the compiler cannot help us and if failure happened, there is no way to figure out what went wrong. Users of your code will have to either guess nullability or inspect the implementation to see if this can happen. Some languages don't support the concept of null. In Java, I find that banning `null` from application logic greatly improves code quality.

### Documentation
```java
interface Baker {  
	/**
	  * This can fail in the following ways:
	  * 1) The oven is broken
	  * 2) We ran out of tomatoes
	  * 3) ... etc
	  */
    Pizza createPizza();  
}
```
The implied expectation here is that users have to read every function to see if it can fail, and to repeat this every time they update to a newer version of your API. Perhaps they will have to write unit test for all of the failure paths to feel safe. Documentation can be valuable, but it is not a good fit for this purpose.

### Declare Unchecked exceptions

```java
interface Baker {
    Pizza createPizza() throws RuntimeException;
}
```

While this expresses the possibility of failure in a mechanism that the language is aware of, handling is not required. The failure is put in the same bucket as severe runtime failures such as out of memory errors. While using subclassed `RuntimeException`  may help in readability and more targeted handling, I think we can do better.

### Declare Checked exceptions

```java
interface Baker {
    Pizza createPizza() throws Exception;
}
```

The first solution where the compiler will not allow us to ignore the possibility of failure. However, this requires a `throws` clause at the call site or forces `try/catch` blocks.

If the call site method already contained a `throws Exception` clause, the possibility of failure may be overlooked entirely. Similarly, if a `try/catch` block was already present, no error handling is is required and no compiler error or warning is emitted.

Intuitively I find using `Exception` and  `try/catch` like using sledgehammers to crack a nut. A failed `Pizza` is a valid case in our business logic that does not require interrupting normal application flow nor building stacktraces. We need something way simpler.

### Either
```java
interface Baker {  
    Either<Failure, Pizza> createPizza();  
}
```
We finally have arrived at an expressive, type-safe API. Calling `createPizza` will give us a type containing either a failure or the pizza. For `Java` the type can be supplied by a functional programming library like [[Vavr]], and implementations exists for most programming languages where functional programming is viable.

Since the type is not directly usable as an instance of `Pizza` but instead (maybe) contains it, it requires some work on behalf of the programmer to resolve the possibility of getting a `Failure`, with the compiler assisting you every step of the way. The `Either` type is specifically designed to help you do this. 

The implementation (or substitution) of the `Failure` type is a choice made with different concerns in mind, which I will leave out of scope here.

## Conclusion

I've been using `Either` to express error paths in core domain functions, and it is tremendously useful in reducing the amount of errors that propagate upwards, since every error needs to be considered when using the API. In my experience it leads to code that is both simpler to understand and very error resilient.

---
## Appendix

### Option
``
```java
interface Baker {  
    Option<Pizza> createPizza();  
}
```

When you use `Option` as a return type, you signal that absence is to be expected, and you will not explain why. This is great when the reason for absence is clear, for example a function which tries to find something that may not exist. The `Option` type expresses this very clearly.
In our example, the baker needs to tell us what went wrong, so `Option` is not a good fit here.

### Wrapper
```java
interface Baker {  
    MaybePizza createPizza();  
}
```

Using a custom return value can increase or decrease the expressiveness and ease of use of the API. This can be very useful for example when more context information needs to be included in case of failure. A common example is a `Parser` which may use a `ParseResult` 

```java
interface Parser<T> {
	ParseResult<T> parse(String input);
}
```
