{-# LANGUAGE OverloadedStrings #-}
module Web.Views.Impressum where

import Web.Views.Home
import Text.Blaze.Html5 as H
import Text.Blaze.Html5.Attributes as A
import qualified Data.Text as T


viewImpressum :: H.Html
viewImpressum = docTypeHtml $ do
    H.head $ do
        getMenuBarHeader
    H.body $ do
        H.div ! A.class_  "mdl-layout mdl-js-layout mdl-layout--fixed-drawer" $ do
            getMenuBarBody
