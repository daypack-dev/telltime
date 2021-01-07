open Cmdliner

let expr_arg =
  let doc = "Duration expression" in
  Arg.(required & pos 0 (some string) None & info [] ~docv:"EXPR" ~doc)

let run (duration_expr : string) : unit =
  match Timere_parse.duration duration_expr with
  | Error msg -> print_endline msg
  | Ok duration ->
    let duration_in_seconds = Timere.Duration.to_seconds duration in
    Printf.printf "Now                   : %s\n"
      (Timere.sprintf_timestamp ~display_using_tz:Config.cur_tz
         Config.cur_timestamp);
    Printf.printf "Duration (original)   : %s\n" duration_expr;
    Printf.printf "Duration (normalized) : %s\n"
      (Timere.Duration.sprint duration);
    Printf.printf "Now + duration        : %s\n"
      (Timere.sprintf_timestamp ~display_using_tz:Config.cur_tz
         (Int64.add Config.cur_timestamp duration_in_seconds))

let cmd = (Term.(const run $ expr_arg), Term.info "from-now")
