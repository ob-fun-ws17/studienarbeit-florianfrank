{-# LANGUAGE OverloadedStrings #-}
-- | Module shows Impressum View
module Web.Views.Impressum
    (viewImpressum) where

-- import internal modules
import              Web.Views.Home -- Home contains function to create menu

-- import external modules
import              Text.Blaze.Html5 as H
import qualified    Text.Blaze.Html5.Attributes as A


-- | create impressum html page
viewImpressum :: H.Html -- ^ html page
viewImpressum = docTypeHtml $ do
    H.head $ do
        getMenuBarHeader
        H.link ! A.rel "stylesheet" ! A.href "/css/impressum.css"
    H.body $ do
        H.div ! A.class_  "mdl-layout mdl-js-layout mdl-layout--fixed-drawer" $ do
            getMenuBarBody
            H.hgroup $ do
                H.h3 "Impressum"
                H.form $ do
                    H.text "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labor"
