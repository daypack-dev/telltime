open Cmdliner

let run () : unit =
  ()

let cmd =
  ( Term.(const run),
    Term.info "search"
  )
