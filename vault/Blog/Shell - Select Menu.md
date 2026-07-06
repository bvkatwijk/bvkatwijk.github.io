---
aliases:
tags:
  - shell
  - bash
date: 2026-07-01T20:07:35+00:00
lastmod: 2026-07-01T20:08:13+00:00
---
In Bash it is easy to quickly create a selection mode where the user selects one of the supported options:

```bash
#!/usr/bin/env bash
FRUITS=("apple" "banana")

select fruit in "${FRUITS[@]}"; do
    case "$fruit" in
        "apple") apple ; break ;;
        "banana") banana ; break ;;
    esac
done
```

This displays the options and asks the user to provide a numbered selection:

```
1) apple
2) banana
#? 
```
