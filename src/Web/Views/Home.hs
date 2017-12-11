{-# LANGUAGE OverloadedStrings #-}
module Web.Views.Home where

import Control.Monad (forM_)
import Text.Blaze.XHtml5 ((!))
import qualified Text.Blaze.Bootstrap as H
import Text.Blaze.Html5 as H
import Text.Blaze.Html5.Attributes as A
import Text.Blaze.Html (Html, toHtml)

getMenuBarHeader :: H.Html
getMenuBarHeader = docTypeHtml $ do
         H.title "Home"
         H.meta    ! A.name "viewport"  ! A.content "width = device-width, initial-scale = 2"
         H.link    ! A.rel "stylesheet" ! A.href "https://storage.googleapis.com/code.getmdl.io/1.0.6/material.indigo-pink.min.css"
         H.script  ! A.src "https://storage.googleapis.com/code.getmdl.io/1.0.6/material.min.js" $ ""
         H.link    ! A.rel "stylesheet" ! A.href "https://fonts.googleapis.com/icon?family=Material+Icons"

getMenuBarBody :: H.Html
getMenuBarBody =
       H.div ! A.class_  "mdl-layout mdl-js-layout mdl-layout--fixed-drawer" $
        H.div ! A.class_ "mdl-layout__drawer" $ do
            H.p $ do
                H.span ! A.class_ "mdl-layout-title" $  "   Atemschutzplaner"
                H.nav ! A.class_ "mdl-navigation" $ do
                    H.a ! A.class_ "mdl-navigation__link"  ! A.href "/home" $ "Home"
                    H.a ! A.class_ "mdl-navigation__link" ! A.href "/membermanagement" $ "Mitgliederverwaltung"
                    H.a ! A.class_ "mdl-navigation__link" ! A.href "/appointmentmanagement" $ "Terminverwaltung"
                    H.a ! A.class_ "mdl-navigation__link" ! A.href "/impressum" $ "Impressum"
                    H.a ! A.class_ "mdl-navigation__link" ! A.href "logout" $ "Logout"

viewHome :: H.Html
viewHome = docTypeHtml $ do
    H.head $ do
        getMenuBarHeader
        H.link ! A.rel "stylesheet" ! A.href "/css/login.css"
    H.body $ do
        getMenuBarBody
        H.hgroup $ do
            H.h1 "Login Atemschutzplaner"
            H.h3 "by Florian Frank"
        H.form $ do
            H.div ! A.class_ "group" $ do
                H.input ! A.type_ "text"
                H.span ! A.class_ "highlight" $ ""
                H.span ! A.class_ "bar" $ ""
                H.label "Name"
            H.div ! A.class_ "group" $ do
                H.input ! A.type_ "email"
                H.span ! A.class_ "highlight" $ ""
                H.span ! A.class_ "bar" $ ""
                H.label "Name"
            H.button ! A.type_ "button" ! A.class_ "button buttonBlue" $ "Subscribe"
            H.div $ do
                H.div ! A.class_ "ripples buttonRipples" $ do
                    H.span ! A.class_ "ripplesCircle" $ ""
