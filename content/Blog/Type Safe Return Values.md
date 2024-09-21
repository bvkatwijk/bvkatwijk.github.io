---
aliases: 
tags:
  - java
  - api
  - dx
  - fp
title: Type Safe Return Values
date: 2024-09-18T13:33:23+00:00
lastmod: 2024-09-18T15:40:14+00:00
---
When writing high-level business logic, I prefer to expose an API that uses type safe constructs. An critical part is the return value.

Suppose we design an API for baking pizza:

```java
record Pizza() { }
```

Let's design a `Baker` capable of creating `Pizza`. I'll be using an `interface` since the actual logic is not relevant for this example. 

Unfortunately our `Baker` sometimes runs out of ingredients. However, our API does not reveal this fact. We can choose how we are going to express the possible paths of failure, and listed below are some common options. I frequently encounter solutions that results in poor handling and developer ergonomics.

### Don't: Rely on Nullity
```java
interface Baker {  
    Pizza createPizza();  
}
```

Returning `null` may be the worst option. It does not express the possibility of failure in any way, and if failure happened, there is no way to figure out what went wrong. It would be great if this would be disallowed at the language level.

### Don't: Documentation
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

### Don't: Declare Unchecked exceptions

```java
interface Baker {
    Pizza createPizza() throws RuntimeException;
}
```

While this expresses the possibility of failure in a mechanism that the language is aware of, handling is not required. The failure is put in the same bucket as severe runtime failures such as out of memory errors. While using subclassed `RuntimeException`  may help in readability and more targeted handling, I think we can do better.

### Don't: Declare Checked exceptions

```java
interface Baker {
    Pizza createPizza() throws Exception;
}
```

The first solution where the compiler will not allow us to ignore the possibility of failure. However, this requires a `throws` clause at the call site or forces `try/catch` blocks.

If the call site already contained a `throws Exception` clause, the possibility of failure may be overlooked entirely. Similarly, if a `try/catch` block was already present, no error handling is is required and no compiler error or warning is emitted.

Intuitively I find using `Exception` and  `try/catch` like using sledgehammers to crack a nut. A failed `Pizza` is a valid case in our business logic that does not require interrupting normal application flow nor building elaborate stacktraces. We need something way simpler.

### Do: Either
```java
interface Baker {  
    Either<Failure, Pizza> createPizza();  
}
```
We finally have arrived at an expressive type-safe API. Calling `createPizza` will give us the a type containing either a failure or the pizza. Resolving this requires some work on behalf of the programmer, with the compiler assisting you every step of the way. For java the type can be supplied by a functional programming library like [Vavr]({{< ref "Vavr" >}}), and implementations exists for most programming languages where functional programming is viable.

The implementation (or substitution) of the `Failure` type is a choice made with different concerns in mind, which I will cover in [Error Values]({{< ref "Error Values" >}})

---
## Addenda

### Using Option
``
```java
interface Baker {  
    Option<Pizza> createPizza();  
}
```

When you use `Option` as a return type, you signal that absence is to be expected, and you will not explain why. This is great when the reason for absence is clear, which is not the case in our example.

### Using Wrapper
```java
interface Baker {  
    MaybePizza createPizza();  
}
```

Using a custom return value can increase or decrease the expressiveness and ease of use of the API.