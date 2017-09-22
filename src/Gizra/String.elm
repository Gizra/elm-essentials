module Gizra.String exposing (requireAndStripPrefix, startsWithOneOf, endsWithOneOf, replacePrefixWith, addLeadingZero, addLeadingZeroes, isBlank)

import Maybe.Extra exposing (isJust)
import String exposing (startsWith, dropLeft, length, endsWith, padLeft)
import Regex exposing (regex)


{-| Checks whether the string starts with one of the provided prefixes.
If so, strips the prefix and returns the result. If not, returns `Nothing`.
Checks the prefixes in order, and uses the first which matches.

    "https://www.youtube.com/watch?v=abcdefghijklmnop"
        |> requireAndStripPrefix
            [ "https://www.youtube.com/watch?v="]
    --> Just "abcdefghijklmnop"

    "https://www.youtube.com/watch?v=abcdefghijklmnop"
        |> requireAndStripPrefix
            [ "https://www.youtube.com/watch?v="
            , "https://youtu.be/"
            ]
    --> Just "abcdefghijklmnop"

    "https://www.youtube.com/watch?v=abcdefghijklmnop"
        |> requireAndStripPrefix
            [ "https://youtu.be/"
            , "https://www.youtube.com/watch?v="
            ]
    --> Just "abcdefghijklmnop"

    "https://www.youtube.com/watch?v=abcdefghijklmnop"
        |> requireAndStripPrefix []
    --> Nothing

    "https://www.youtube.com/watch?v=abcdefghijklmnop"
        |> requireAndStripPrefix
            [ "https://apple.com/"
            , "https://microsoft.com"
            ]
    --> Nothing

-}
requireAndStripPrefix : List String -> String -> Maybe String
requireAndStripPrefix prefixes string =
    case validate string startsWith prefixes of
        Just prefix ->
            dropLeft (length prefix) string |> Just

        _ ->
            Nothing


{-| Checks whether the string starts with one of the provided prefixes.
If so, returns the prefix.
-}
startsWithOneOf : List String -> String -> Bool
startsWithOneOf prefixes string =
    validate string startsWith prefixes |> isJust


{-| Checks whether the string ends with one of the provided prefixes.
If so, returns the suffix.
-}
endsWithOneOf : List String -> String -> Bool
endsWithOneOf suffixes string =
    validate string endsWith suffixes |> isJust


{-| If string start with prefix, replace the prefix in string with newPrefix.
Otherwise, just return the string.
-}
replacePrefixWith : String -> String -> String -> String
replacePrefixWith prefix newPrefix string =
    if startsWith prefix string then
        newPrefix ++ dropLeft (length prefix) string
    else
        string


validate : String -> (String -> String -> Bool) -> List String -> Maybe String
validate string function options =
    case options of
        option :: rest ->
            if function option string then
                Just option
            else
                -- Recursively check the rest of the suffixes.
                -- This should be tail-call optimized by the compiler,
                -- so we shouldn't need to worry about the stack.
                validate string function rest

        [] ->
            Nothing


{-| Pad the string to the desired length by adding leading zeroes.
-}
addLeadingZeroes : Int -> String -> String
addLeadingZeroes desiredLength =
    padLeft desiredLength '0'


{-| Add a leading zero to ensure that the string length is 2.
-}
addLeadingZero : String -> String
addLeadingZero =
    addLeadingZeroes 2


{-| Is the string empty or composed only of whitespace?
-}
isBlank : String -> Bool
isBlank string =
    Regex.contains (regex "^\\s*$") string
