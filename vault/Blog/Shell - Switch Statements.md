---
aliases: 
tags:
  - shell
  - bash
  - switch
title: Shell - Switch Statements
lastmod: 2024-09-28T13:34:38+00:00
GHissueID: "7"
date: 2024-09-21T21:28:03+00:00
---
Recently I had to work a bit more than usual on shell scripting, and had to do a bunch of switches. I used this also in the scripts for this project. A simplified impression shows how we can match user input with supported commands:

```sh
#!/bin/sh
CMD=$1
case "$CMD" in
	"run") echo "cmdRun" ;;
	"publish") echo "cmdPublish" ;;
	*) echo "Unknown command $CMD"; exit 1 ;;
esac
```

This way we can match the provided input with supported cases (`"run"` and `"publish"`), and error otherwise (`*`). The double semicolon (`;;`) marks the end of a case.
