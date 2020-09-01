open Cmdliner

let cmds = [ Search_cmd.cmd ]

let default_cmd = (Term.(ret (const (`Help (`Pager, None)))), Term.info "telltime")

let () = Term.(exit @@ Term.eval_choice default_cmd cmds)
