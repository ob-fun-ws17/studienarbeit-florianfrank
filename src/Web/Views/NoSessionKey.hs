{-# LANGUAGE OverloadedStrings #-}
-- | Module shows NoSessionKeyView
module Web.Views.NoSessionKey where

import Web.Views.Home
import Text.Blaze.Html5 as H
import Text.Blaze.Html5.Attributes as A
import qualified Data.Text as T

-- | create nosessionkey html page
viewNoSessionKey :: H.Html  -- ^ html page
viewNoSessionKey = docTypeHtml $ do
    H.head $ do
        getMenuBarHeader
        H.link ! A.rel "stylesheet" ! A.href "/css/impressum.css"
    H.body $ do
        H.div ! A.class_  "mdl-layout mdl-js-layout mdl-layout--fixed-drawer" $ do
            getMenuBarBody
            H.hgroup $ do
                H.form $ do
                    H.h3 "Kein Zugriff. Sie müssen sich zuerst einloggen."
