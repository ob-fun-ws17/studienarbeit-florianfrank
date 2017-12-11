{-# LANGUAGE OverloadedStrings #-}
module Web.Views.Home where

import Control.Monad (forM_)
import Text.Blaze.XHtml5 ((!))
import qualified Text.Blaze.Bootstrap as H
import Text.Blaze.Html5 as H
import Text.Blaze.Html5.Attributes as A
import Text.Blaze.Html (Html, toHtml)

viewHome :: H.Html
viewHome = docTypeHtml $ do
    H.head $ do
             H.title "Home"
             H.meta    ! A.name "viewport"  ! A.content "width = device-width, initial-scale = 2"
             H.link    ! A.rel "stylesheet" ! A.href "https://storage.googleapis.com/code.getmdl.io/1.0.6/material.indigo-pink.min.css"
             H.script  ! A.src "https://storage.googleapis.com/code.getmdl.io/1.0.6/material.min.js" $ ""
             H.link    ! A.rel "stylesheet" ! A.href "https://fonts.googleapis.com/icon?family=Material+Icons"

    H.body $ do
       H.div ! A.class_  "mdl-layout mdl-js-layout mdl-layout--fixed-drawer" $
        H.div ! A.class_ "mdl-layout__drawer" $ do
            H.p $ do
                H.span ! A.class_ "mdl-layout-title" $ "Atemschutzplaner"
                H.nav ! A.class_ "mdl-navigation" $ do
                    H.a ! A.class_ "mdl-navigation__link"  ! A.href "" $ "Home"
                    H.a ! A.class_ "mdl-navigation__link" ! A.href "" $ "Mitgliederverwaltung"
                    H.a ! A.class_ "mdl-navigation__link" ! A.href "" $ "Terminverwaltung"
                    H.a ! A.class_ "mdl-navigation__link" ! A.href "" $ "Impressum"
                    H.a ! A.class_ "mdl-navigation__link" ! A.href "" $ "Logout"
