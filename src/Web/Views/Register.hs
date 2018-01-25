{-# LANGUAGE OverloadedStrings #-}
-- | Module shows Register View
module Web.Views.Register
    (viewRegister) where

-- import internal Modules
import Web.Views.Home -- Home contains function to create menu

-- import external modules
import                  Text.Blaze.Html5 as H
import qualified        Text.Blaze.Html5.Attributes as A
import                  Text.Blaze.Html (Html, toHtml)


-- | create register html page
viewRegister :: H.Html  -- ^ html page
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
            H.form ! A.class_ "loginRegisterForm" $ do
                H.div ! A.class_ "group" $ do
                    H.input ! A.type_ "text" ! A.id "mail"
                    H.span ! A.class_ "highlight" $ ""
                    H.span ! A.class_ "bar" $ ""
                    H.label "Name"
                H.div ! A.class_ "group" $ do
                    H.input ! A.type_ "password" ! A.id "password"
                    H.span ! A.class_ "highlight" $ ""
                    H.span ! A.class_ "bar" $ ""
                    H.label "Passwort"
                H.div ! A.class_ "group" $ do
                    H.input ! A.type_ "password" ! A.id "passwordRepeat"
                    H.span ! A.class_ "highlight" $ ""
                    H.span ! A.class_ "bar" $ ""
                    H.label "Passwort wiederholen"
                H.button ! A.type_ "button" ! A.onclick "register()" ! A.class_ "button buttonBlue" $ "Register"
                H.button ! A.type_ "button" ! A.onclick "window.location.href='/home'" ! A.class_ "button buttonGreen" $ "Back"
