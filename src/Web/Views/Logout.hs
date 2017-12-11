{-# LANGUAGE OverloadedStrings #-}
module Web.Views.Logout where

import Web.Views.Home
import Text.Blaze.Html5 as H
import Text.Blaze.Html5.Attributes as A
import qualified Data.Text as T


viewLogout :: H.Html
viewLogout = docTypeHtml $ do
    H.head $ do
        getMenuBarHeader
    H.body $ do
        getMenuBarBody
