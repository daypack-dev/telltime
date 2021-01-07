let cur_tz_offset_s = Ptime_clock.current_tz_offset_s () |> CCOpt.get_exn

let cur_tz =
  Timere.Time_zone.make_offset_only ~name:"OS current local time zone offset"
    cur_tz_offset_s

let cur_timestamp = Timere.cur_timestamp ()

let default_search_years_ahead = 5

let default_time_slot_count = 10
