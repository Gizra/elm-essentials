[![Build Status](https://travis-ci.org/Gizra/elm-essentials.svg?branch=master)](https://travis-ci.org/Gizra/elm-essentials)

# elm-essentials

This package represents an attempt to factor out a variety of small utilities that
are commonly used in Gizra projects.

- It is a companion to [drupal-elm-starter](https://github.com/Gizra/drupal-elm-starter).
  `drupal-elm-starter` represents an entire (but simple) sample app, whereas this contains
  pieces of code as a package that can be used in multiple projects.

- It includes things that don't fit easily into more focused Gizra packages, such as:

    - [Gizra/elm-all-set](http://package.elm-lang.org/packages/Gizra/elm-all-set/latest)

      A set of unique values. The values can be any type (not just comparables).

    - [Gizra/elm-attribute-builder](http://package.elm-lang.org/packages/Gizra/elm-attribute-builder/latest)

      Build up lists of HTML attributes in a modular manner

    - [Gizra/elm-compat-018](http://package.elm-lang.org/packages/Gizra/elm-compat-018/latest)

      Compatibility layer for use with Elm 0.18

    - [Gizra/elm-dictlist](http://package.elm-lang.org/packages/Gizra/elm-dictlist/latest)

      Dict with arbitrary ordering (like List)

    - [Gizra/elm-editable-webdata](http://package.elm-lang.org/packages/Gizra/elm-editable-webdata/latest)

      An EditableWebData represents an Editable value, along with WebData.

    - [Gizra/elm-keyboard-event](http://package.elm-lang.org/packages/Gizra/elm-keyboard-event/latest)

      Decoders for keyboard events

    - [Gizra/elm-storage-key](http://package.elm-lang.org/packages/Gizra/elm-storage-key/latest)

      A StorageKey represents a value that is either New or Existing.


## Other Packages

In the spirit of identifying essentials, here are some packages which are used
in many Gizra projects.

    - [rgrempel/elm-route-url](http://package.elm-lang.org/packages/rgrempel/elm-route-url/latest)

      Router for single-page-apps in Elm

    - [elm-community/list-extra](http://package.elm-lang.org/packages/elm-community/list-extra/latest)

      Convenience functions for working with List

    - [elm-community/maybe-extra](http://package.elm-lang.org/packages/elm-community/maybe-extra/latest)

      Convenience functions for working with Maybe
