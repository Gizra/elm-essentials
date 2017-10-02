module Gizra.Date exposing (allMonths, formatDDMMYY, formatDDMMYYhhmm)

{-| Some functions for working with dates.

@docs formatDDMMYY, formatDDMMYYhhmm, allMonths

-}

import Date exposing (Date, Month(..), month, year, hour, minute)
import Date.Extra.Facts exposing (months, monthNumberFromMonth)
import Gizra.String exposing (addLeadingZero)
import List.Extra exposing (elemIndex)


{-| Format a date using the supplied delimiter.

    import Date exposing (fromString)
    import Result exposing (Result(Ok), map)

    fromString "February 3, 1971"
        |> map (formatDDMMYY "-")
    --> Ok "03-02-71"

    fromString "February 3, 1971"
        |> map (formatDDMMYY "/")
    --> Ok "03/02/71"

    fromString "October 2, 2005"
        |> map (formatDDMMYY "-")
    --> Ok "02-10-05"

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

    fromString "February 3, 1971 2:03 PM"
        |> map (formatDDMMYYhhmm "-")
    --> Ok "03-02-71 14:03"

    fromString "February 3, 1971 12:04 PM"
        |> map (formatDDMMYYhhmm "/")
    --> Ok "03/02/71 12:04"

    fromString "October 2, 2005 4:12 PM"
        |> map (formatDDMMYYhhmm "-")
    --> Ok "02-10-05 16:12"

-}
formatDDMMYYhhmm : String -> Date -> String
formatDDMMYYhhmm delimiter date =
    -- See comment above re: argument order.
    (formatDDMMYY delimiter date) ++ " " ++ (hour date |> toString |> addLeadingZero) ++ ":" ++ (minute date |> toString |> addLeadingZero)


monthMM : Date -> String
monthMM =
    month >> monthNumberFromMonth >> toString >> addLeadingZero


yearYY : Date -> String
yearYY date =
    (year date) % 100 |> toString |> addLeadingZero


{-| A list of all the months, in the traditional order.
-}
allMonths : List Month
allMonths =
    months
