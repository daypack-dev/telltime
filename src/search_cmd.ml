open Cmdliner

type time_format =
  [ `Plain_human_readable
  | `Plain_unix_second
  ]

let tz_arg =
  let doc = "Time zone" in
  Arg.(value & opt (some string) None & info [ "tz" ] ~docv:"NAME" ~doc)

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
  Arg.(value & opt (some string) None & info [ "format" ] ~doc)

let sep_arg =
  let doc = "Separator" in
  Arg.(value & opt string "\n" & info [ "sep" ] ~doc)

let expr_arg =
  let doc = "Time expression" in
  Arg.(required & pos 0 (some string) None & info [] ~docv:"EXPR" ~doc)

let run (tz_name : string option) (search_years_ahead : int)
    (time_slot_count : int) (sep : string) (expr : string) : unit =
  match Timere_parse.timere expr with
  | Error msg -> print_endline msg
  | Ok timere -> (
      let search_start = Config.cur_timestamp in
      let search_end_exc =
        Int64.add
          Timere.Duration.(
            make ~days:(search_years_ahead * 365) () |> to_seconds)
          search_start
      in
      let timere =
        let open Timere in
        inter [ timere; interval_exc Config.cur_timestamp search_end_exc ]
      in
      let tz =
        match tz_name with
        | None -> Ok Config.cur_tz
        | Some tz_name -> Timere.Time_zone.make tz_name
      in
      match tz with
      | Error () -> print_endline "Invalid time zone name"
      | Ok tz -> (
          match Timere.resolve ~search_using_tz:Config.cur_tz timere with
          | Error msg -> print_endline msg
          | Ok s -> (
              Printf.printf "Searching in time zone : %s\n"
                (Timere.Time_zone.name tz);
              Printf.printf
                "Search by default starts from (in above time zone) : %s\n"
                (Timere.sprintf_timestamp ~display_using_tz:tz search_start);
              print_newline ();
              match s () with
              | Seq.Nil -> print_endline "No matching time slots"
              | Seq.Cons _ ->
                s
                |> OSeq.take time_slot_count
                |> OSeq.iteri (fun i ts ->
                    let s =
                      Timere.sprintf_interval ~display_using_tz:tz ts
                    in
                    if i = 0 then Printf.printf "%s" s
                    else Printf.printf "%s%s" sep s);
                print_newline () ) ) )

let cmd =
  ( (let open Term in
     const run
     $ tz_arg
     $ search_years_ahead_arg
     $ time_slot_count_arg
     $ sep_arg
     $ expr_arg),
    Term.info "search" )
