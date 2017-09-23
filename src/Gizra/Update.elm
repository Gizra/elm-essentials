module Gizra.Update exposing (sequenceExtra)

{-| Some conveniences for implementing the `update` function.

Using the various functions in
[ccapndave/elm-update-extra](http://package.elm-lang.org/packages/ccapndave/elm-update-extra/latest)
is also highly recommended.

@docs sequenceExtra

-}

import List


{-| Like `Update.Extra.sequence`, but for `update` signatures that also
return a list of extra messages for the caller to handle.

Essentially, this allows you to recusively apply a whole sequence of messages,
collecting their results. So, with `Update.Extra.sequence` you can do something
like this:

    update : Msg -> Model -> ( Model, Cmd Msg )
    update msg model =
        case msg of
            SomeMsg ->
                sequence update
                    [ AnotherMsg, YetAnotherMsg, AThirdMsg ]
                    ( model, Cmd.none )

Isn't that nice? Essentially, you get a really expressive way of constructing
a "composite" message. Plus, you can do something first ... that is, you could
modify the model, and have your own `Cmd`, and then feed that into the `sequence`
for further processing.

So, what is `sequenceExtra`? It deals with an alternative `update` signature,
in which we're returning a third element to our tuple, with extra messages that
the caller is expected to handle. So, you can follow the same idiom as shown above.

    update : Msg -> Model -> ( Model, Cmd Msg, List extraMsg )
    update msg model =
        case msg of
            SomeMsg ->
                sequenceExtra update
                    [ AnotherMsg, YetAnotherMsg, AThirdMsg ]
                    ( model, Cmd.none, [] )

-}
sequenceExtra :
    (msg -> model -> ( model, Cmd msg, List extraMsg ))
    -> List msg
    -> ( model, Cmd msg, List extraMsg )
    -> ( model, Cmd msg, List extraMsg )
sequenceExtra updater msgs startingPoint =
    List.foldl
        (\eachMsg ( modelSoFar, cmdsSoFar, msgsSoFar ) ->
            let
                ( newModel, newCmd, newMsgs ) =
                    updater eachMsg modelSoFar
            in
                ( newModel
                , Cmd.batch [ cmdsSoFar, newCmd ]
                , msgsSoFar ++ newMsgs
                )
        )
        startingPoint
        msgs
