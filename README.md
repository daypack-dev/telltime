# telltime
Tiny cli tool for evaluating Daypack time expression into matching time slots

## Possible uses

- For scripts to check if time is within time slots specified by time expression
- Looking up the exact date for sentences we often use, e.g. "thu 9am to 12pm"
- Do some operations over time slots, set operators such as `&&` (intersect), `||` (union) are available

## Online demo

- The engine that evaluates the time expression can be accessed via this online [demo](https://daypack-dev.github.io/time-expr-demo/)
- Note that the online demo may be more limiting than `telltime` itself, due to memory space restriction of JS being run in a browser
  - In other words, if `telltime` might still return something useful even if the demo failed for a particular input
