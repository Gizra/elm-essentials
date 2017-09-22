module Gizra.Date exposing (formatDDMMYY, formatDDMMYYhhmm)

{-| Some functions for working with dates.

@docs formatDDMMYY, formatDDMMYYhhmm

-}

import Date exposing (Date, Month(..), month, year, hour, minute)
import Gizra.String exposing (addLeadingZero)
import List.Extra exposing (elemIndex)


{-| Format a date using the supplied delimiter.

With a delimiter of '-', you might end up with '27-03-95'.

-}
formatDDMMYY : String -> Date -> String
formatDDMMYY delimiter date =
    -- The argument order is flipped from previous versions. When establishing
    -- argument order, think about how you might want to curry a function. In
    -- this case, it might be convenient to partially apply the delimiter
    -- parameter, so that you end up with a function that always use that
    -- delimiter, and takes a date. So, it's convenient to make the delimiter
    -- the first argument.
    (Date.day date |> toString |> addLeadingZero) ++ delimiter ++ monthMM date ++ delimiter ++ yearYY date


{-| Format a data using the supplied delimiter.

With a delimiter of '-', you might end up with '27-03-95 12:43'.

-}
formatDDMMYYhhmm : String -> Date -> String
formatDDMMYYhhmm delimiter date =
    -- See comment above re: argument order.
    (formatDDMMYY delimiter date) ++ " " ++ (hour date |> toString |> addLeadingZero) ++ ":" ++ (minute date |> toString |> addLeadingZero)


monthMM : Date -> String
monthMM date =
    case elemIndex (month date) monthList of
        Just index ->
            index + 1 |> toString |> addLeadingZero

        Nothing ->
            -- Will never get here, as long as monthList is properly defined.
            Debug.crash "Internal error in Gizra.Date.monthMM"


yearYY : Date -> String
yearYY date =
    (year date) % 100 |> toString |> addLeadingZero


monthList : List Month
monthList =
    [ Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec ]
