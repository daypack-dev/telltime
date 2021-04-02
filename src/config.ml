let default_date_time_format_string =
  "{year} {mon:Xxx} {mday:0X} {hour:0X}:{min:0X}:{sec:0X} \
   {tzoff-sign}{tzoff-hour:0X}:{tzoff-min:0X}:{tzoff-sec:0X}"

let default_interval_format_string =
  "[{syear} {smon:Xxx} {smday:0X} {shour:0X}:{smin:0X}:{ssec:0X} \
   {stzoff-sign}{stzoff-hour:0X}:{stzoff-min:0X}:{stzoff-sec:0X}, {eyear} \
   {emon:Xxx} {emday:0X} {ehour:0X}:{emin:0X}:{esec:0X} \
   {etzoff-sign}{etzoff-hour:0X}:{etzoff-min:0X}:{etzoff-sec:0X})"

let tz = Timere.Time_zone.name @@ Option.get @@ Timere.Time_zone.local ()

let cur_timestamp = Timere.timestamp_now ()

let default_search_years_ahead = 5

let default_time_slot_count = 10
