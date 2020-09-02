open Cmdliner

type time_format = [
  | `Plain_human_readable
  | `Plain_unix_second
]

let search_years_ahead_arg =
  let doc = "Number of years to search ahead" in
  let open Arg in
  value
  & opt int Config.default_search_years_ahead
  & info [ "years-ahead" ] ~docv:"N" ~doc

let time_slot_count_arg =
  let doc = "Number of time slots to display" in
  let open Arg in
  value
  & opt int Config.default_time_slot_count
  & info [ "time-slots" ] ~docv:"N" ~doc

let time_format_arg =
  let doc = "Format to output in" in
  let open Arg in
  value
  & opt (enum [("human", `Plain_human_readable);
               ("unix", `Plain_unix_second);
              ]) `Plain_human_readable
  & info [ "format" ] ~docv:"N" ~doc

let expr_arg =
  let doc = "Time expression" in
  Arg.(required & pos 0 (some string) None & info [] ~docv:"EXPR" ~doc)

let run (search_years_ahead : int) (time_slot_count : int) (output_mode : time_format)(expr : string) :
  unit =
  let search_param =
    Misc_utils.make_search_param ~search_years_ahead
      ~from_unix_second:Config.cur_unix_second
  in
  match Daypack_lib.Time_expr.of_string expr with
  | Error msg -> print_endline msg
  | Ok expr -> (
      match Daypack_lib.Time_expr.matching_time_slots search_param expr with
      | Error msg -> print_endline msg
      | Ok s -> (
          match s () with
          | Seq.Nil -> print_endline "No matching time slots"
          | Seq.Cons _ ->
            s
            |> OSeq.take time_slot_count
            |> (match output_mode with
                | `Plain_human_readable ->
                  Seq.iter (fun (x, y) ->
                      let x =
                        Daypack_lib.Time.To_string
                        .yyyymondd_hhmmss_string_of_unix_second
                          ~display_using_tz_offset_s:Config.tz_offset_s x
                        |> Result.get_ok
                      in
                      let y =
                        Daypack_lib.Time.To_string
                        .yyyymondd_hhmmss_string_of_unix_second
                          ~display_using_tz_offset_s:Config.tz_offset_s y
                        |> Result.get_ok
                      in
                      Printf.printf "[%s, %s)\n" x y
                    )
                | `Plain_unix_second ->
                  Seq.iter (fun (x, y) ->
                      Printf.printf "[%Ld, %Ld)\n" x y
                    )
              )
        )
    )

let cmd =
  ( Term.(const run $ search_years_ahead_arg $ time_slot_count_arg $ time_format_arg $ expr_arg),
    Term.info "search" )
