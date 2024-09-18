---
aliases: 
tags: 
title: Java - Unique Enum Field values
date: 2024-09-18T11:51:15+00:00
lastmod: 2024-09-18T12:25:17+00:00
---
When you have a [Java Enum](https://www.baeldung.com/a-guide-to-java-enums) with a field, a requirement can be that the field value needs to be unique. Using a utility method it can be easy to create a test for this. Given an Enum class with a field (using some [[Lombok]]):**

```java
@Getter
@RequiredArgsConstructor
@Accessors(fluent = true)
public enum Sides {  
    LEFT("left"),  
    RIGHT("right");  
  
    final String label;
}
```

You can enforce uniqueness using a unit test:

```java
  
import io.vavr.collection.HashMap;  
import io.vavr.collection.Vector;  
import org.junit.jupiter.api.Test;  
  
import java.util.function.Function;  
  
import static org.junit.jupiter.api.Assertions.assertEquals;  
  
class SidesTest {  
    @Test  
    void unique() {  
        assertUnique(Sides.values(), Sides::label);  
    }  
  
    private static <T> void assertUnique(T[] values, Function<T, String> fieldValue) {  
        assertEquals(  
            HashMap.empty(),  
            Vector.of(values)  
                .groupBy(fieldValue)  
                .filter(it -> it._2().size() > 1));  
    }  
}
```

The test will automatically validate that all fields have distinct values, even if the Enum expands or changes in the future. Failures will report the enum values that have the same property. If we misconfigure the enum above ( `RIGHT("left")`) we see:

```
Expected :HashMap()
Actual   :LinkedHashMap((left, Vector(LEFT, RIGHT)))
```