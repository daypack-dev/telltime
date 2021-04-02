open Cmdliner

let run () : unit =
  List.iter (fun s -> print_endline s) Timere.Time_zone.available_time_zones

let cmd = (Term.(const run $ const ()), Term.info "time-zones")
