---
aliases: 
tags:
  - java
  - json
  - test
  - api
date: 2025-02-04T16:19:25+00:00
lastmod: 2025-02-04T16:38:07+00:00
title: Json Unit Testing
---
Many applications have APIs consuming and returning JSON. If you do not cover the expected inputs and output of the API you risk introducing unintentional changes. Luckily it is not hard to create these valuable test cases.
If you have types that are used both as symmetrical inputs and outputs this test pattern will provide full coverage and give you utility methods for other tests as well.

For this example I'll be using a type `Task` having just a `name` and a `description` field, both `String`s:
```java
record Task(String name, String description) { }
```

### Unit testing
We need a base class to test the JSON conversion, and we initialize an `ObjectMapper` to convert our class.
```java
class TaskJsonTest { 
    static final ObjectMapper mapper = new ObjectMapper();
}
```
 If your application customizes the mapper (for example, in Spring Boot applications), call that factory method here instead of the default one to have accurate tests.
### Serialization
Converting a type into JSON is called **serialization**. We need a testcase to validate that, given an instance of the response type, the resulting json is what we expect it to be. The `JSONAssert` library provides functionality to compare JSON to see if it is the same values (ignoring formatting differences):
```java
    @Test  
    void serialize() throws Exception {  
        JSONAssert.assertEquals(  
            expectedJson,  
            mapper.writeValueAsString(instance),  
            true  
        );  
    }  
```

We will have to set up `expectedJson`, and provide an `instance`. Before we do this, lets first consider the deserialization test case.
### Deserialization
If there are also endpoints accepting this type as json, you can cover this with a **deserialization** test. This way, we know that deserialization succeeds and produces exactly the data that we expect.

```java
@Test  
    void deserialize() throws Exception {  
        assertEquals(  
            expectedInstance,  
            mapper.readValue(json, Task.class)  
        );  
    }
```

Here all that is left to do is providing `expectedInstance` and the `json` value. 
### Instance creation and conversion function
We see a similarity in these tests, both need an instance of the type, and a json string that represents it in its serialized form. If we create a random instance of our type, and provide a function to convert it to JSON, we can set up both tests cases.

The random instance can be declared as a field (or as a constant if you are using immutable programming). A library like `instancio` can help us out:
```java
Task instance = Instancio.create(Task.class);
```
The conversion method can be a function if you keep it stateless.
```java
    static JSONObject json(Task it) {  
        return new JSONObject()  
            .put("name", it.name())  
            .put("description", it.description()));  
    }
```

### Full Testcase
We can now use the created instance and function to validate that both serialization and deserialization provide correct results:
```java
class TaskJsonTest {  
    ObjectMapper mapper = new ObjectMapper();  
    Task instance = Instancio.create(Task.class);  
  
    @Test  
    void deserialize() throws Exception {  
        assertEquals(  
            instance,  
            mapper.readValue(json(instance).toString(), Task.class)  
        );  
    }  
  
    @Test  
    void serialize() throws Exception {  
        JSONAssert.assertEquals(  
            json(instance).toString(),  
            mapper.writeValueAsString(instance),  
            true  
        );  
    }  
  
    static JSONObject json(Task it) {  
        return new JSONObject()  
            .put("name", it.name())  
            .put("description", it.description()));  
    }
}
```
### Nested types
This pattern comes in very handy when dealing with nested types. For example, suppose we add an `Assignee` to a `Task`:
```java
record Task(String name, String description, Assignee assignee) { }
```
If we already have an `AssigneeJsonTest`, all we have to do to adapt the `TaskJsonTest` is register the conversion in the `json` function:
```java
    static JSONObject json(Task it) {  
        return new JSONObject()  
            .put("name", it.name())  
            .put("description", it.description())
            .put("assignee", AssigneeJsonTest.json(it.assignee())));  
    }
```

### Spring Boot
In a Spring Boot application, use a `@JsonTest` annotation and autowire a `JacksonTester` instead:
```java
@JsonTest
class TaskJsonTest {
    @Autowired JacksonTester<Task> mapper;
}
```

### Notes
- I like to use random instances as it continuously will validate different data, providing a lot more powerful testing than a fixed-value unit test without having to go full property-based testing.
- 