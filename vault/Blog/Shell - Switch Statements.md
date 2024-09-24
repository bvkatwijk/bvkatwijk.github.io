---
aliases: 
tags: 
title: Shell - Switch Statements
date: 2024-09-21T21:28:03+00:00
lastmod: 2024-09-24T16:33:02+00:00
---
Recently I found out that in `shell` scripts it is quite easy to do handle a switch with cases


```sh
#!/bin/sh
CMD=$1
case $CMD in
	"run") echo "cmdRun" ;;
	"publish") echo "cmdPublish" ;;
	*) echo "Unknown command $CMD"; exit 1 ;;
esac
```

This makes it easy to do 