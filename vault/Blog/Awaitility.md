---
aliases: 
tags:
  - devoxx
  - java
  - test
  - dx
  - api
  - short
  - spring
date: 2024-10-07T10:01:38+00:00
lastmod: 2024-10-07T19:20:35+00:00
title: Awaitility
featured_image: /images/awaitility.png
GHissueID: "11"
---
Writing tests on asynchronous code can be a challenge. Given an asynchronous process to test, we may try to use custom code to wait for the process to finish or reach a certain state. This may cause us to end up with tests that are flaky, slow, or hard to understand. It is not uncommon for legacy projects to have these setups, and perhaps they can be improved a little.

[Awaitility](http://www.awaitility.org/) provides a nice DSL to help us out. We can easily specify the condition we wait for and the maximum amount of time to wait.

As an example, let us use an `AtomicReference` as a thread-safe value container for a result String:

```java
var result = new AtomicReference<>("");
```

We use an asynchronous process that waits an unknown amount of seconds before setting a result value:

```java
new Thread(() -> {  
    try { Thread.sleep(A_FEW_SECONDS); } catch (Exception e) {}  
    result.set("done!");  
}).start();
```

We would like to wait until the result is ready. Let's choose five seconds as the maximum amount of time to wait. Using Awaitility's declarative API, it's easy to specify how long to wait and which condition to verify:

```java
Awaitility.await()  
    .atMost(Duration.ofSeconds(5))  
    .until(() -> result.get().equals("done!"));
```
 
 Internally, Awaitility will repeatedly check the condition until success or until timeout. It has a rich fluent DSL to add configuration. Awaitility is [included in Spring Boot Starter Test](https://github.com/spring-projects/spring-boot/issues/37195) by default. 
 
 [Daniel Garnier-Moiroux](https://github.com/Kehrlann) showed this tool in action In his presentation [Spring Boot testing: Zero to Hero](https://devoxx.be/talk/spring-boot-testing-zero-to-hero/) at [Devoxx Belgium 2024](https://devoxx.be/).
 
 Happy testing!
### Links
- [Awaitility Home Page](http://www.awaitility.org/)
- [Awaitility on Maven Repository](https://mvnrepository.com/artifact/org.awaitility/awaitility)
