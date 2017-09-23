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
-}
sequenceExtra :
    (msg -> model -> ( model, Cmd msg, List extraMsg ))
    -> List msg
    -> ( model, Cmd msg, List extraMsg )
    -> ( model, Cmd msg, List extraMsg )
sequenceExtra updater msgs ( previousModel, previousCmd, previousMsgs ) =
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
        ( previousModel, previousCmd, previousMsgs )
        msgs
