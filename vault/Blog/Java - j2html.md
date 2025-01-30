---
aliases:
  - j2html
tags:
  - java
  - ssr
  - dx
  - html
  - tools
date: 2025-01-30T10:33:19+00:00
lastmod: 2025-01-30T12:18:49+00:00
---
For my full-stack projects I like to use Server-Side rendering with [Javalin](https://javalin.io/), [j2html](https://j2html.com/) and [htmx](https://htmx.org/). Together, these libraries allow you to write interactive full-stack web applications in vanilla java. In this post I'd like to explain how the [j2html](https://j2html.com/) library fits in this setup, go over a few benefits, and link a [converter](https://bvankatwijk.nl/j2html-converter/) that I wrote to make building the user interface easier.
### Server Side Rendering
While the last decade was dominated by client-side frameworks, many applications could perhaps have saved a lot of development time by using server-side rendering. This means that the resulting page is built on the server, including its data, styling and behaviour.

With the incredible stability and performance of servers and networks nowadays, a lot of arguments to move work to the client side have become less relevant. Servers can render the page within a millisecond and the client can immediately display it without invoking front-end data processing. With parallel processing, servers can easily handle thousands of requests per second.
### Suitable projects
Not every project is a great fit, but in my view, too many B2B projects reach for elaborate heavy frameworks by default without considering the speed and simplicity of just doing all the work on the server. The most suitable projects are administrative business projects needing to show data fast, reliable and cleanly.
### Benefits
Using j2html for server-side rendering gives you a number of immediate benefits:
#### 1. No Framework
Since it is just a libary, learning [j2html](https://j2html.com/) takes about ten seconds. There is no framework to learn. This allows you and your team to use the tool you already know best - the programming language itself - without spending time learning a lot of framework quirks.
#### 2. No API
Since there is no front-end framework demanding an API to communicate with, you can skip creating it entirely. Not having to create and maintain an API saves a lot of time and effort.
#### 3. No business logic replication
Another benefit is that business logic stays in one place and does not have to be replicated inside front-end code. This can save an enormous amount of time up front, and when evolving a project. Changing a business rule can be done in a single place in server-side code. 
#### 4. No HTML duplication
HTML has no built-in way to reuse code. Creating your html with vanilla java means that you can reuse any html by extracting it. There is no need to learn how components work in the front-end framework (or web components).

The reduction in project size and complexity is also illustrated in [Radical Simplicity](https://www.radicalsimpli.city/). The amount of time needed to change a business rule or implement a new feature is cut down from days to hours, if not minutes.
### HTML to j2html
Building a UI quickly can involve copy-pasting ready made HTML, so we need a way to quickly convert it to j2html code. I've written an [online converter ](https://bvankatwijk.nl/j2html-converter/) that fulfills this purpose. Please consider starring it, and if you notice missing or incorrect behaviour, consider creating an issue. Contributions are also more than welcome! If you like the library, consider starring [j2html on GitHub](https://github.com/tipsy/j2html).