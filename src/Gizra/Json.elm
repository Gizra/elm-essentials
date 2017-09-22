module Gizra.Json
    exposing
        ( encodeDict
        , encodeAnyDict
        , decodeInt
        , decodeIntToString
        , decodeFloat
        , decodeIntDict
        , decodeEmptyArrayAs
        , decodeJsonInString
        )

{-| Utilities for dealing with JSON.


## Dictionaries

@docs encodeDict, encodeAnyDict, decodeIntDict


## Numbers

@docs decodeInt, decodeIntToString, decodeFloat


## Arrays

@docs decodeEmptyArrayAs


## Strings

@docs decodeJsonInString

-}

import Dict exposing (Dict)
import Json.Decode exposing (..)
import Json.Decode.Extra exposing (dict2)
import Json.Encode exposing (object)
import String


{-| Given a function which encodes a dict's values, encode the `Dict` as a JSON
object, using the dict's keys as the keys for the JSON object.
-}
encodeDict : (v -> Value) -> Dict String v -> Value
encodeDict =
    encodeAnyDict identity


{-| Like `encodeDict`, but you also supply a way of turning the keys into
strings.
-}
encodeAnyDict : (comparable -> String) -> (v -> Value) -> Dict comparable v -> Value
encodeAnyDict keyFunc valueFunc =
    Dict.toList
        >> List.map (\( key, value ) -> ( keyFunc key, valueFunc value ))
        >> object


{-| Cast String to Int
-}
decodeInt : Decoder Int
decodeInt =
    oneOf
        [ int
        , string
            |> andThen
                (\s ->
                    case String.toInt s of
                        Ok value ->
                            succeed value

                        Err err ->
                            fail err
                )
        ]


{-| Cast to String
-}
decodeIntToString : Decoder String
decodeIntToString =
    oneOf
        [ string
        , int |> andThen (\v -> succeed (toString v))
        ]


{-| Cast String to Float
-}
decodeFloat : Decoder Float
decodeFloat =
    oneOf
        [ float
        , string
            |> andThen
                (\s ->
                    case String.toFloat s of
                        Ok value ->
                            succeed value

                        Err err ->
                            fail err
                )
        ]


{-| Given a decoder for the values, decode a dictionary that has integer keys.
The resulting decoder will fail if any of the keys can't be converted to an `Int`.
-}
decodeIntDict : Decoder value -> Decoder (Dict Int value)
decodeIntDict =
    dict2 decodeInt


{-| If given an empty array, decodes it as the given value. Otherwise, fail.
-}
decodeEmptyArrayAs : a -> Decoder a
decodeEmptyArrayAs default =
    list value
        |> andThen
            (\list ->
                let
                    length =
                        List.length list
                in
                    if length == 0 then
                        succeed default
                    else
                        fail <| "Expected an empty array, not an array with length: " ++ toString length
            )


{-| This is for JSON which is embedded as a string value. Given a decoder, this
will produce a decoder that first decodes a string, and then run the supplied
decoder on that JSON string.
-}
decodeJsonInString : Decoder a -> Decoder a
decodeJsonInString decoder =
    string
        |> andThen
            (\s ->
                case decodeString decoder s of
                    Ok a ->
                        succeed a

                    Err err ->
                        fail err
            )
