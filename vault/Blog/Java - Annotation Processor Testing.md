---
aliases: 
tags:
  - java
  - annotations
  - test
date: 2025-03-13T12:47:34+00:00
lastmod: 2025-03-13T14:35:43+00:00
title: Annotation Processor Testing
---
Creating an Annotation Processor means that you will likely also add tests, but you can run into some issues since the runtime is the compilation process itself - meaning that you will have multiple options when it comes to testing. In this post I'd like to outline what you can do to ensure proper test coverage.

### Annotation Processing
In Java, Annotations allow compile-time metaprogramming, meaning that it allows creating code based on other source code. I use this in [[Java - Lenses]] to create auxiliary classes for annotated records. These contain various instances and functions which need the type information of the annotated records, meaning that there is no way to this directly in the source code itself.

### Testing
Writing an annotation processor is done in Java, and we can use the testing tools that we are familiar with. But an important consideration is that we have various contexts in which our code can be tested. Aside from default vanilla unit tests on regular code:

- We want to run our annotation processor on actual source code and verify the output
- We want to run unit tests on logic that handles internal compilation types instantiated during the annotation processor process.

### E2E Test

We can create an end-to-end test of our annotation processor by applying the following steps:
- Create a source file
- Invoke a compilation process with our annotation processor specified
- Validating the resulting created file(s)

We do this by:
- Adding a source file under `src/test/resources` (or `src/test/java` if you want to also use it elsewhere)
- Add our project to the `testAnnotationProcessor` configuration
- Use Google's [compile-testing](https://mvnrepository.com/artifact/com.google.testing.compile/compile-testing) to initialize a compilation process on the source file
- Compare the output using [Approval Testing](https://mvnrepository.com/artifact/com.approvaltests/approvaltests)

The resulting test case looks like this:

```java
@Test  
@SneakyThrows  
void verifyOutput() {  
    Compilation compile = Compiler.javac()  
        .withProcessors(new LensProcessor())
        .compile(load("nl/bvkatwijk/lens/example/Person.java"));  
    assertThat(compile).succeeded();  
    Approvals.verify(compile.generatedSourceFiles()  
        .getFirst()  
        .getCharContent(true)  
        .toString());  
}  
  
@SneakyThrows  
static JavaFileObject load(String packagePath) {  
    Path path = Paths.get("src/test/java", packagePath);  
    return JavaFileObjects.forSourceString(  
        packagePath.replace('/', '.').replace(".java", ""),  
        Files.readString(path));  
}
```

### Unit testing on compile-time instances

Since I also have intermediary logic during the annotation processing I would like to unit test it too. However, instantiating or mocking the values that result from such a process is both tedious and does not prove anything about the real process. So I would like to start annotation processing and capture the values I am interested in so that I can validate small pieces of logic.

For example, I have a function to extract the name of the field parameter in a `record`:
```java
public static String fieldName(RecordComponentElement it) {  
    return it.getSimpleName().toString();  
}
```

`RecordComponentElement` is an instance created during the annotation processing. I capture these during annotation processing:

```java
@Getter  
@SupportedSourceVersion(SourceVersion.RELEASE_23)  
@SupportedAnnotationTypes(Const.LENS_ANNOTATION_QUALIFIED)  
public class LensProcessor extends AbstractProcessor {  
    @NonFinal  
    List<RecordComponentElement> elements = List.of();
  
	@Override  
	@SneakyThrows  
	public boolean process(Set<? extends TypeElement> annotations, RoundEnvironment roundEnv) {
		// ...
		this.elements = elements.appendAll(elements);
		// ...
	}
}
```

This way, we can call our function under test using the resulting values inside the processor field:
```java
@Test  
@SneakyThrows  
void verifyOutput() {  
	var lensProcessor = new LensProcessor();
    Compilation compile = Compiler.javac()  
        .withProcessors(lensProcessor)
        .compile(load("nl/bvkatwijk/lens/example/Person.java"));  
    assertThat(compile).succeeded();  
    var element = lensProcessor.elements().head();
    assertEquals("street", ElementOps.fieldName(STRING_STREET));  
}  
```

---

## Appendix

### Add Lombok to the compilation process

In my case, I use `Lombok` in the source code that I want to compile, meaning that I also have to supply `Lombok` to the compile process. This is done by adding Lombok to the `testImplementation` configuration. Normally `Lombok` only requires `testCompileOnly`
 and `testAnnotationProcessor`, or sometimes it is not used in the `test` configurations at all.

We then load their annotation processors dynamically since they are hidden from us:

```java
var lombokAnnotationProcessor = getClass().getClassLoader().loadClass("lombok.launch.AnnotationProcessorHider$AnnotationProcessor");  
var lombokClaimingProcessor = getClass().getClassLoader().loadClass("lombok.launch.AnnotationProcessorHider$ClaimingProcessor");
```

And hook them into the compilation process:

```java
Compiler.javac()  
    .withProcessors(  
        (Processor) lombokAnnotationProcessor.getDeclaredConstructor().newInstance(),  
        (Processor) lombokClaimingProcessor.getDeclaredConstructor().newInstance(),  
        lensProcessor)
```