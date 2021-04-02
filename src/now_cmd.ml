open Cmdliner

let run () : unit =
  Fmt.pr "%a\n"
    ( Timere.pp_timestamp ()) Config.cur_timestamp

let cmd = (Term.(const run $ const ()), Term.info "now")
