module Gizra.NominalDate
    exposing
        ( NominalDate
        , NominalDateRange
        , decodeDrupalRange
        , decodeYYYYMMDD
        , encodeDrupalRange
        , encodeYYYYMMDD
        , formatMMDDYYYY
        , formatYYYYMMDD
        , fromLocalDateTime
        )

{-| Some utilities for dealing with "pure" dates that have no time or
time zone information.

@docs NominalDate, decodeYYYYMMDD, encodeYYYYMMDD, formatYYYYMMDD, formatMMDDYYYY, fromLocalDateTime


## Ranges

@docs NominalDateRange, decodeDrupalRange, encodeDrupalRange

-}

import Date
import Date.Extra.Facts exposing (monthNumberFromMonth)
import Gizra.String exposing (addLeadingZero, addLeadingZeroes)
import Json.Decode exposing (Decoder, andThen, string)
import Json.Decode.Extra exposing (fromResult)
import Json.Decode.Pipeline exposing (decode, required)
import Json.Encode exposing (Value, object)
import Time.Date exposing (day, fromISO8601, month, year)


{-| An alias for `Time.Date.Date` from elm-community/elm-time. Represents
a "pure" date without any time information or time zone information.

This is basically to avoid confusion between `Time.Date.Date` and the
`Date.Date` in elm-lang/core.

-}
type alias NominalDate =
    Time.Date.Date


{-| A range of nominal dates, with a start and end.

Both the start and end date are included in the range.

-}
type alias NominalDateRange =
    { start : NominalDate
    , end : NominalDate
    }


{-| Convert a nominal date to formatted string.

    import Time.Date exposing (date)

    formatMMDDYYYY (date 2017 5 2) --> "05/02/2017"

-}
formatMMDDYYYY : NominalDate -> String
formatMMDDYYYY date =
    addLeadingZero (toString (month date)) ++ "/" ++ addLeadingZero (toString (day date)) ++ "/" ++ addLeadingZeroes 4 (toString (year date))


{-| Convert nominal date to a formatted string..

    formatYYYYMMDD (date 2017 5 2) --> "2017-05-02"

-}
formatYYYYMMDD : NominalDate -> String
formatYYYYMMDD date =
    addLeadingZeroes 4 (toString (year date)) ++ "-" ++ addLeadingZero (toString (month date)) ++ "-" ++ addLeadingZero (toString (day date))


{-| Converts an `elm-lang/core` `Date` to a `NominalDate`.

We pick up the date part according to whatever the local browser's time zone
is. Thus, results will be inconsistent from one locality to the next ... since
the same universal time might be considered one day in one time zone and a
different day in a different time zone.

-}
fromLocalDateTime : Date.Date -> NominalDate
fromLocalDateTime date =
    Time.Date.date (Date.year date) (monthNumberFromMonth (Date.month date)) (Date.day date)


{-| Decodes nominal date from string of the form "2017-02-20".

    import Json.Decode exposing (..)

    decodeString decodeYYYYMMDD """ "2017-02-20" """ --> Ok (date 2017 02 20)

-}
decodeYYYYMMDD : Decoder NominalDate
decodeYYYYMMDD =
    andThen (fromResult << fromISO8601) string


{-| Encode nominal date to string of the form "2017-02-20".

    import Json.Encode exposing (encode)

    encodeYYYYMMDD (date 2017 2 20)
        |> encode 0 --> "\"2017-02-20\""

-}
encodeYYYYMMDD : NominalDate -> Value
encodeYYYYMMDD =
    Json.Encode.string << formatYYYYMMDD


{-| Given a decoder, Decodes a range as Drupal sends it, with a `value` and `value2`.

    """
        { "value": "2017-07-21"
        , "value2": "2017-07-23"
        }
    """
        |> decodeString (decodeDrupalRange decodeYYYYMMDD)
    --> Ok
            { start = date 2017 07 21
            , end = date 2017 07 23
            }

-}
decodeDrupalRange : Decoder NominalDate -> Decoder NominalDateRange
decodeDrupalRange decoder =
    decode NominalDateRange
        |> required "value" decoder
        |> required "value2" decoder


{-| Given an encoder, encodes a range as Drupal expects it, with a `value` and `value2`.

    { start = date 2017 07 21
    , end = date 2017 07 23
    }
        |> encodeDrupalRange encodeYYYYMMDD
        |> encode 0
    --> """{"value":"2017-07-21","value2":"2017-07-23"}"""

-}
encodeDrupalRange : (NominalDate -> Value) -> NominalDateRange -> Value
encodeDrupalRange encoder range =
    object <|
        [ ( "value", encoder range.start )
        , ( "value2", encoder range.end )
        ]
