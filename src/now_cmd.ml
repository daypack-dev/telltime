open Cmdliner

let run () : unit =
  print_endline
    ( Timere.sprintf_timestamp ~display_using_tz:Config.cur_tz
        Config.cur_timestamp
    )

let cmd = (Term.(const run $ const ()), Term.info "now")
