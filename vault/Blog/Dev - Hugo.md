---
aliases: 
tags:
  - web
  - dx
date: 2024-09-24T18:48:00+00:00
lastmod: 2024-09-28T13:29:28+00:00
title: Hugo
GHissueID: "4"
---
This website was made using [Hugo](https://gohugo.io/), following the quick start tutorial and iterating from there. So far its been a lot of fun, and gradually expanding website functionality has been a very natural process.

### Content
I use [Obsidian](https://obsidian.md/) to create my content, allowing me to write using [MarkDown](https://en.wikipedia.org/wiki/Markdown). Using [Obsidian Linter](https://github.com/platers/obsidian-linter) I can automatically insert [YAML](https://en.wikipedia.org/wiki/YAML) properties that Hugo will pick up as metadata.
Using this setup there is a nice separation between site content and site functionality.

### Rendering
I use [obsidian-to-hugo](https://github.com/devidw/obsidian-to-hugo) to transform the Obsidian vault into Hugo-compatible markdown files. Among other things, this keeps links intact.

### Publication
Using Hugo, I publish the site into the `/docs` directory and push it, where Github Pages automatically hosts the site for me. 

### Github Comments
Comments are available via Github Issues. When browsing to a page, if an issue link exists the comments will be displayed under it. I followed the strategy outlined in this [blog post](https://decovar.dev/blog/2019/04/19/github-comments-hugo/). I added a script to automatically create issues for pages which do not have an issue id linked.

