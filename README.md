# telltime
Cli tool for interacting with Daypack-lib components

## Examples

#### Search for time slots matching Daypack time expression

```
$ telltime search --time-slots 5 --years 100 "feb 29 00:00"
Searching in time zone offset (seconds)            : 36000
Search by default starts from (in above time zone) : 2020 Sep 03 19:24:15

Matching time slots (in above time zone):
[2024 Feb 29 00:00:00, 2024 Feb 29 00:00:01)
[2028 Feb 29 00:00:00, 2028 Feb 29 00:00:01)
[2032 Feb 29 00:00:00, 2032 Feb 29 00:00:01)
[2036 Feb 29 00:00:00, 2036 Feb 29 00:00:01)
[2040 Feb 29 00:00:00, 2040 Feb 29 00:00:01)
```

#### Search for all Australia ACT 2020 public holidays that fall on weekends

```
$ telltime search "( \
  (2020 . jan . 1, 27 . 00:00 to 23:59) \
  || (2020 . mar . 9 . 00:00 to 23:59) \
  || (2020 . apr . 10 to 13, 25, 27 . 00:00 to 23:59) \
  || (2020 . jun . 1, 8 . 00:00 to 23:59) \
  || (2020 . oct . 5 . 00:00 to 23:59) \
  || (2020 . dec . 25, 26 . 00:00 to 23:59) \
) \
&& w[sat,sun]hm"
Searching in time zone offset (seconds)            : 36000
Search by default starts from (in above time zone) : 2020 Sep 04 00:07:27

Matching time slots (in above time zone):
[2020 Dec 26 00:00:00, 2020 Dec 26 23:59:00)
```

#### Get exact time after some duration from now

```
$ telltime from-now "1 hour"
Now                   : 2020-09-03 15:53:29
Duration (original)   : 1 hour
Duration (normalized) : 1 hours 0 mins 0 secs
Now + duration        : 2020-09-03 16:53:29
```

```
$ telltime from-now "1.5 hour"
Now                   : 2020-09-03 15:54:24
Duration (original)   : 1.5 hour
Duration (normalized) : 1 hours 30 mins 0 secs
Now + duration        : 2020-09-03 17:24:24
```

```
$ telltime from-now "1.5 days 2.7 hours 0.5 minutes"
Now                   : 2020-09-03 15:55:43
Duration (original)   : 1.5 days 2.7 hours 0.5 minutes
Duration (normalized) : 1 days 14 hours 42 mins 30 secs
Now + duration        : 2020-09-05 06:38:13
```

#### Get time right now

```
$ telltime now
2020-09-03 15:57:39
```

## Possible uses

- For scripts to check if time is within time slots specified by time expression
- Looking up the exact date for sentences we often use, e.g. "thu 9am to 12pm"
- Do some operations over time slots, set operators such as `&&` (intersect), `||` (union) are available

## Online demo

- The engine that evaluates the time expression can be accessed via this online [demo](https://daypack-dev.github.io/time-expr-demo/)
- Note that the online demo may be more limiting than `telltime` itself, due to memory space restriction of JS being run in a browser
  - In other words, if `telltime` might still return something useful even if the demo failed for a particular input
