---
aliases: 
tags:
  - shell
  - bash
  - switch
title: Shell - Switch Statements
date: 2024-09-21T21:28:03+00:00
lastmod: 2024-09-28T08:58:52+00:00
GHissueID: "2"
---
Recently I had to work a bit more than usual on shell scripting, and had to do a bunch of switches. I used this also in the scripts for this project. A simplified impression shows how we could implement a very basic CLI, matching the input with supported commands:

```sh
#!/bin/sh
CMD=$1
case $CMD in
	"run") echo "cmdRun" ;;
	"publish") echo "cmdPublish" ;;
	*) echo "Unknown command $CMD"; exit 1 ;;
esac
```

This way we can match the provided input with supported cases (`"run"` and `"publish"`), and error otherwise (`*`). 

The double semicolon (`;;`) marks the end of a case.