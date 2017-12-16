{-# LANGUAGE OverloadedStrings #-}
module Web.Views.Register where

import Web.Views.Home

import Control.Monad (forM_)
import Text.Blaze.XHtml5 ((!))
import qualified Text.Blaze.Bootstrap as H
import Text.Blaze.Html5 as H
import Text.Blaze.Html5.Attributes as A
import Text.Blaze.Html (Html, toHtml)


viewRegister :: H.Html
viewRegister = docTypeHtml $ do
    H.head $ do
        getMenuBarHeader
        H.link ! A.rel "stylesheet" ! A.href "/css/login.css"
        H.script ! A.src "https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js" ! A.type_ "text/javascript" $ ""
        H.script ! A.src "/js/register.js" ! A.type_ "text/javascript" $ ""
    H.body $ do
        H.div ! A.class_  "mdl-layout mdl-js-layout mdl-layout--fixed-drawer" $ do
            getMenuBarBody
            H.hgroup $ do
                H.h1 "Register"
                H.h3 "Insert your mail and password here"
            H.form $ do
                H.div ! A.class_ "group" $ do
                    H.input ! A.type_ "text" ! A.id "mail"
                    H.span ! A.class_ "highlight" $ ""
                    H.span ! A.class_ "bar" $ ""
                    H.label "Name"
                H.div ! A.class_ "group" $ do
                    H.input ! A.type_ "email" ! A.id "password"
                    H.span ! A.class_ "highlight" $ ""
                    H.span ! A.class_ "bar" $ ""
                    H.label "Passwort"
                H.button ! A.type_ "button" ! A.onclick "register()"! A.class_ "button buttonBlue" $ "Register"
