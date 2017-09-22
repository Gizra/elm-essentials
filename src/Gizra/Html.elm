module Gizra.Html
    exposing
        ( divKeyed
        , emptyNode
        , floatToPx
        , intToPx
        , keyed
        , keyedDivKeyed
        , preventDefault
        , preventDefaultAndStopPropagation
        , stopPropagation
        , showIf
        )

{-| Utilities for working with `Html`


## Keyed

@docs keyed, divKeyed, keyedDivKeyed


## Options

@docs preventDefault, stopPropagation, preventDefaultAndStopPropagation


## Conditionally show HTML

@docs showIf, emptyNode


## CSS pixels

@docs intToPx, floatToPx

-}

import Html exposing (..)
import Html.Events exposing (Options)
import Html.Keyed
import Round


{-| A convenience for keyed divs.
-}
divKeyed : List (Attribute msg) -> List ( String, Html msg ) -> Html msg
divKeyed =
    Html.Keyed.node "div"


{-| Like `divKeyed`, but also gives the resulting div a key.
-}
keyedDivKeyed : String -> List (Attribute msg) -> List ( String, Html msg ) -> ( String, Html msg )
keyedDivKeyed key attrs children =
    keyed key <|
        divKeyed attrs children


{-| A convenience for putting things in keyed elements.
-}
keyed : String -> Html msg -> ( String, Html msg )
keyed =
    (,)


{-| Convert integer to CSS px
-}
intToPx : Int -> String
intToPx val =
    (toString val) ++ "px"


{-| Convert float to CSS px, with just 1 decimal point, since a px
is already pretty small.
-}
floatToPx : Float -> String
floatToPx val =
    (Round.round 1 val) ++ "px"


{-| Shorthand for event options.
-}
preventDefaultAndStopPropagation : Options
preventDefaultAndStopPropagation =
    { preventDefault = True
    , stopPropagation = True
    }


{-| Shorthand for event options.
-}
stopPropagation : Options
stopPropagation =
    { preventDefault = False
    , stopPropagation = True
    }


{-| Shorthand for event options.
-}
preventDefault : Options
preventDefault =
    { preventDefault = True
    , stopPropagation = False
    }


{-| Produces an empty text node in the DOM.
-}
emptyNode : Html msg
emptyNode =
    text ""


{-| Conditionally show Html. A bit cleaner than using if expressions in middle
of an html block:

    showIf True <| text "I'm shown"

    showIf False <| text "I'm not shown"

-}
showIf : Bool -> Html msg -> Html msg
showIf condition html =
    if condition then
        html
    else
        emptyNode
