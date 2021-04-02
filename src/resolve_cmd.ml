open Cmdliner

type time_format =
  [ `Plain_human_readable
  | `Plain_unix_second
  ]

let tz_arg =
  let doc = "Time zone" in
  Arg.(value & opt string Config.tz & info [ "tz" ] ~docv:"N" ~doc)

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
  & opt string Config.default_interval_format_string
  & info [ "format" ] ~doc

let sep_arg =
  let doc = "Separator" in
  Arg.(value & opt string "\n" & info [ "sep" ] ~doc)

let expr_arg =
  let doc = "Time expression" in
  Arg.(required & pos 0 (some string) None & info [] ~docv:"EXPR" ~doc)

let run (tz : string) (search_years_ahead : int) (time_slot_count : int)
    (format : string) (sep : string) (expr : string) : unit =
  match Timere.Time_zone.make tz with
  | None -> print_endline "Unrecognized time zone"
  | Some tz -> (
      match Timere_parse.timere expr with
      | Error msg -> print_endline msg
      | Ok timere -> (
          let search_end_exc =
            Int64.add Config.cur_timestamp
              Timere.(
                Duration.make ~days:(search_years_ahead * 365) ()
                |> Duration.to_seconds)
          in
          let timere =
            let open Timere in
            inter
              [ timere; intervals [ (Config.cur_timestamp, search_end_exc) ] ]
          in
          match Timere.resolve timere with
          | Error msg -> print_endline msg
          | Ok s -> (
              Fmt.pr "Searching in time zone (seconds)            : %s\n"
                (Timere.Time_zone.name tz);
              Fmt.pr "Search by default starts from (in above time zone) : %a\n"
                (Timere.pp_timestamp ~display_using_tz:tz
                   ~format:Config.default_date_time_format_string ())
                Config.cur_timestamp;
              print_newline ();
              match s () with
              | Seq.Nil -> print_endline "No matching time slots"
              | Seq.Cons _ ->
                s
                |> OSeq.take time_slot_count
                |> OSeq.iteri (fun i ts ->
                    let s =
                      Timere.string_of_interval ~display_using_tz:tz
                        ~format ts
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
     $ format_string_arg
     $ sep_arg
     $ expr_arg),
    Term.info "resolve" )
