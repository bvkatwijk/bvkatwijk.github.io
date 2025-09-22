---
aliases:
tags:
  - aws
  - cdk
  - java
  - test
  - dx
date: 2025-09-22T14:41:38+00:00
lastmod: 2025-09-22T14:41:46+00:00
---
With [AWS CDK](https://github.com/aws/aws-cdk), you can practice infrastructure-as-code using your programming language of choice. Since this code is setting up cloud infrastructure, many classical unit testing approaches are not feasible. Adding Approval Testing to your project can increase confidence and safety.

Examples here will use Java, but the principles work in any language, and [appropriate libraries](https://approvaltests.com/) are available.

## Approval Testing

With Approval Tests, you take a snapshot of the output of your code, and verify that this output is consistent with earlier results. If the output has not changed, the test passes. The expected output is not expressed in source code but stored as data in a file. This is also shown in the example on [Approvals](https://approvaltests.com/):

>In normal unit testing, you say `assertEquals(5, person.getAge())`. Approvals allow you to do this when the thing that you want to assert is no longer a primitive but a complex object. For example, you can say, `Approvals.verify(person).`

If the output changes, you will get a test failure and the differences between the expected and actual result is shown.

## CDK

When writing CDK code, you create a runnable `Application` that outputs CloudFormation Templates when run. A simple CDK project could start out like this:

```java
public class Application {
	public static void main(String[] args) {
		var app = new App();
		new MyStack(app);
		app.synth();
		return stacks;
	}
}
```

This will result in a template for `MyStack`, which can be deployed using `cdk`. To disambiguate the different stages of deployment, we call the runtime of this `Application` code **synthesis time**, while **deployment time** is when these templates are actually supplied to CloudFormation. 

## Template Approval

Since the output of CDK code is CloudFormation Templates (expressed in JSON), this makes it very suitable for Approval Testing. You can verify that the output of templates remains the same, and approve changes that occur when adding new features. 

```java
class ApplicationTest {
	@Test
	void approval() {
		Approvals.verify(Template.fromStack(new MyStack(new App()));
	}
}
```

## Full Testing

If you want to automatically test all your stacks, you can use Parametrized Testing. 

First we rewrite our `Application` to provide a way to output all `Stack`s that we create:

```java
public class Application {
	public static void main(String[] args) {
		createStacks();
	}
	
	public static List<Stack> createStacks() {
		var app = new App();
		
		var stacks = List.of(
			new MyStack(app)
		);
		
		app.synth();
		return stacks;
	}
}
```

Test cases will automatically get added when stacks are added to the `createStacks` method:

```java
class ApplicationTest {
	@ParametrizedTest
	@MethodSource("stacks")
	void approval(Stack stack) {
		Approvals.verify(Template.fromStack(stack));
	}
	
	static Stream<Stack> stacks() {
		return Application.createStacks()
			.stream();
	}
}
```

Each `Stack` in the `List` will individually be checked for changes. If anything changes, you will get a popup with the `diff`, with the ability to accept changes.

## Conclusion

- Classic unit testing on CDK code has its limitations, since many changes are not easily tested at synthesis time
- Approval Testing can notify you when outputs change, which is especially useful during refactoring
- Using Parametrized Tests, you can automatically test all stacks present in your application without any extra effort.