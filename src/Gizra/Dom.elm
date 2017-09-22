module Gizra.Dom exposing (Rectangle, currentTarget, target, findAncestor, checkId, decodeDomRect)

{-| Some utility functions for accessing the DOM.

@docs Rectangle, currentTarget, target, findAncestor, checkId, decodeDomRect

-}

import Json.Decode exposing (Decoder, field, at, float, oneOf, fail, succeed, decodeValue, map3, string, map, lazy)
import Json.Decode.Pipeline exposing (decode, required)
import Json.Decode


{-| Applies the supplied decoder to the "target" of the event.
-}
target : Decoder a -> Decoder a
target =
    field "target"


{-| Like `target`, but instead of getting the element that received the
event, this gets the element on which the event handler was placed.
-}
currentTarget : Decoder a -> Decoder a
currentTarget =
    field "currentTarget"


{-| Finds an ancestor for whom the first decoder suceeds. Then, runs the second
decoder on that ancestor. Fails if no ancestor is found, or if it is found and
the decoder fails.
-}
findAncestor : Decoder Bool -> Decoder a -> Decoder a
findAncestor finder decoder =
    let
        checkFinder =
            finder
                |> Json.Decode.andThen
                    (\found ->
                        if found then
                            decoder
                        else
                            fail "Keep trying"
                    )

        checkParent =
            field "parentElement" <|
                lazy (\_ -> findAncestor finder decoder)
    in
        oneOf
            [ checkFinder
            , checkParent
            ]


{-| Types for rectangles.
-}
type alias Rectangle =
    { top : Float
    , left : Float
    , width : Float
    , height : Float
    }


{-| Decodes a `DOMRect` Javascript object.
-}
decodeDomRect : Decoder Rectangle
decodeDomRect =
    decode Rectangle
        |> required "top" float
        |> required "left" float
        |> required "width" float
        |> required "height" float


{-| Given a string, returns a decoder which indicates whether the
`id` field is equal to that string.
-}
checkId : String -> Decoder Bool
checkId id =
    field "id" string
        |> map ((==) id)
