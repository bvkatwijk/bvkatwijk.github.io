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