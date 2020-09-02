let make_search_param ~search_years_ahead ~from_unix_second =
  let open Daypack_lib in
  Search_param.Years_ahead_start_unix_second
    {
      search_using_tz_offset_s = Some Config.tz_offset_s;
      start = from_unix_second;
      search_years_ahead;
    }
