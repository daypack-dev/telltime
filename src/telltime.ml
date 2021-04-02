open Cmdliner

let cmds =
  [ Now_cmd.cmd; Resolve_cmd.cmd; From_now_cmd.cmd; Time_zones_cmd.cmd ]

let default_cmd =
  (Term.(ret (const (`Help (`Pager, None)))), Term.info "telltime")

let () = Term.(exit @@ Term.eval_choice default_cmd cmds)
