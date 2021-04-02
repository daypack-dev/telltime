open Cmdliner

let expr_arg =
  let doc = "Duration expression" in
  Arg.(required & pos 0 (some string) None & info [] ~docv:"EXPR" ~doc)

let run (duration_expr : string) : unit =
  match Timere_parse.duration duration_expr with
  | Error msg -> print_endline msg
  | Ok duration ->
    let duration_in_seconds = Timere.Duration.to_seconds duration in
    Fmt.pr "Now                   : %a\n" (Timere.pp_timestamp ())
      Config.cur_timestamp;
    Fmt.pr "Duration (original)   : %s\n" duration_expr;
    Fmt.pr "Duration (normalized) : %a\n" Timere.Duration.pp duration;
    Fmt.pr "Now + duration        : %a\n" (Timere.pp_timestamp ())
      (Int64.add Config.cur_timestamp duration_in_seconds)

let cmd = (Term.(const run $ expr_arg), Term.info "from-now")
