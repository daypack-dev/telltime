open Cmdliner

let run () : unit =
  print_endline
    ( Timere.sprintf_timestamp
        ~display_using_tz_offset_s:(Config.tz_offset_s)
        Config.default_date_time_format_string
        Config.cur_timestamp
      |> Result.get_ok )

let cmd = (Term.(const run $ const ()), Term.info "now")
