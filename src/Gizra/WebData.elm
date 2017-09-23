module Gizra.WebData exposing (sendWithHandler)

{-| Some functions for working with WebData.

@docs sendWithHandler

-}

import HttpBuilder exposing (..)
import Json.Decode exposing (Decoder, decodeString, succeed)
import RemoteData exposing (RemoteData(..), WebData)
import Http exposing (Error(..), Expect)


{-| This is a convenience for the common pattern where we build a request with
`HttpBuilder` and want to handle the result as a `WebData a`. So, consider someting
like this:

    type alias Model =
        -- Amongst other fields ...
        { liveSessionId : WebData LiveSessionId
        }

    type Msg
        -- Amongst other messages
        = HandleFetchedId (WebData LiveSessionId)

    -- The point is that the `update` method can now be very simple, since what
    -- is passed to `HandleFetchedId` will already be the `WebData ...` we want
    update : Msg -> Model -> (Model, Cmd Msg)
    update msg model =
        case msg of
            HandleFetchedId id ->
                { model | liveSessionId = id } ! []

    -- Given the format of the JSON returned by the server, this picks out the
    -- thing of the type we're interested in
    decodeLiveSessionId : Decode.Decoder LiveSessionId
    decodeLiveSessionId =
        Decode.at [ "data", "live_session" ] decodeInt

    -- You just need to build the `RequestBuilder`, and then call `sendWithHandler`
    fetchFromBackend =
        HttpBuilder.post
            |> -- whatever you need to finish the `RequestBuilder`
            |> sendWithHandler decodeLiveSessionId HandleFetchedId

-}
sendWithHandler : Decoder a -> (WebData a -> msg) -> RequestBuilder any -> Cmd msg
sendWithHandler decoder tagger builder =
    builder
        |> withExpect (Http.expectJson decoder)
        |> HttpBuilder.toTask
        |> RemoteData.asCmd
        |> Cmd.map tagger
