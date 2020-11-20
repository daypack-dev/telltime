open Cmdliner

type time_format =
  [ `Plain_human_readable
  | `Plain_unix_second
  ]

let tz_offset_s_arg =
  let doc = "Time zone offset in seconds" in
  Arg.(value & opt int Config.tz_offset_s & info [ "tz-offset" ] ~docv:"N" ~doc)

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

let format_string_arg =
  let doc = "Format string" in
  let open Arg in
  value
  & opt string
    Config.default_interval_format_string
  & info [ "format" ] ~doc

let sep_arg =
  let doc = "Separator" in
  Arg.(value & opt string "\n" & info [ "sep" ] ~doc)

let expr_arg =
  let doc = "Time expression" in
  Arg.(required & pos 0 (some string) None & info [] ~docv:"EXPR" ~doc)

let run (tz_offset_s : int) (search_years_ahead : int) (time_slot_count : int)
    (format_string : string) (sep : string) (expr : string) : unit =
  match Timere_parse.timere expr with
  | Error msg -> print_endline msg
  | Ok timere -> (
      let cur_date_time =
        Result.get_ok @@ Timere.Date_time.cur ~tz_offset_s_of_date_time:(tz_offset_s) ()
      in
      let search_start_timere =
        Result.get_ok @@
        Timere.of_date_time cur_date_time
      in
      let search_end_exc_timere =
        Timere.(
          shift (Result.get_ok @@ Duration.make ~days:(search_years_ahead * 365) ())
            search_start_timere
        )
      in
      let timere =
        Timere.(
          inter timere
            (interval_exc search_start_timere search_end_exc_timere)
        )
      in
      match Timere.resolve ~search_using_tz_offset_s:tz_offset_s timere with
      | Error msg -> print_endline msg
      | Ok s -> (
          Printf.printf
            "Searching in time zone offset (seconds)            : %d\n"
            tz_offset_s;
          match Timere.Date_time.sprintf format_string
                  cur_date_time
          with
          | Error msg -> Printf.printf "Error: %s\n" msg
          | Ok start_str ->
            Printf.printf
              "Search by default starts from (in above time zone) : %s\n" start_str;
            print_newline ();
            match s () with
            | Seq.Nil -> print_endline "No matching time slots"
            | Seq.Cons _ ->
              s
              |> OSeq.take time_slot_count
              |> OSeq.iteri (fun i ts ->
                  match
                    Timere.sprintf_interval
                      ~display_using_tz_offset_s:tz_offset_s
                      format_string
                      ts
                  with
                  | Ok s ->
                    if i = 0 then Printf.printf "%s" s
                    else Printf.printf "%s%s" sep s
                  | Error msg -> Printf.printf "Error: %s\n" msg);
              print_newline ()
        )
    )

let cmd =
  ( (let open Term in
     const run
     $ tz_offset_s_arg
     $ search_years_ahead_arg
     $ time_slot_count_arg
     $ format_string_arg
     $ sep_arg
     $ expr_arg),
    Term.info "search" )
