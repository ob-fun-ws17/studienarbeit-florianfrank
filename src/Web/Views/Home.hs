{-# LANGUAGE OverloadedStrings #-}
module Web.Views.Home where

import Model.RESTDatatypes

import Control.Monad (forM_)
import Text.Blaze.XHtml5 ((!))
import qualified Text.Blaze.Bootstrap as H
import Text.Blaze.Html5 as H
import Text.Blaze.Html5.Attributes as A
import Text.Blaze.Html (Html, toHtml)
import Data.List as L
import Database.Persist.Sqlite hiding (get)


getMenuBarHeader :: H.Html
getMenuBarHeader = docTypeHtml $ do
         H.title "Home"
         H.meta    ! A.charset "utf-8"
         H.meta    ! A.name "viewport"  ! A.content "width = device-width, initial-scale = 2"
         H.link    ! A.rel "stylesheet" ! A.href "https://storage.googleapis.com/code.getmdl.io/1.0.6/material.indigo-pink.min.css"
         H.script  ! A.src "https://storage.googleapis.com/code.getmdl.io/1.0.6/material.min.js" ! A.type_ "text/javascript" $ ""
         H.link    ! A.rel "stylesheet" ! A.href "https://fonts.googleapis.com/icon?family=Material+Icons"

getMenuBarBody :: H.Html
getMenuBarBody =
    H.div ! A.class_ "mdl-layout__drawer" $ do
        H.p $ do
            H.span ! A.class_ "mdl-layout-title" $  "Atemschutzplaner"
            H.nav ! A.class_ "mdl-navigation" $ do
                H.a ! A.class_ "mdl-navigation__link"  ! A.href "/home" $ "Home"
                H.a ! A.class_ "mdl-navigation__link" ! A.href "/membermanagement" $ "Mitgliederverwaltung"
                H.a ! A.class_ "mdl-navigation__link" ! A.href "/appointmentmanagement" $ "Terminverwaltung"
                H.a ! A.class_ "mdl-navigation__link" ! A.href "/impressum" $ "Impressum"
                H.a ! A.class_ "mdl-navigation__link" ! A.href "logout" $ "Logout"


viewLogin :: H.Html
viewLogin = docTypeHtml $ do
    H.head $ do
        getMenuBarHeader
        H.link ! A.rel "stylesheet" ! A.href "/css/login.css"
        H.script ! A.src "https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js" ! A.type_ "text/javascript" $ ""
        H.script ! A.src "/js/login.js" ! A.type_ "text/javascript" $ ""
    H.body $ do
        H.div ! A.class_  "mdl-layout mdl-js-layout mdl-layout--fixed-drawer" $ do
            getMenuBarBody
            H.hgroup $ do
                H.h1 "Login Atemschutzplaner"
                H.h3 "by Florian Frank"
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
                H.button ! A.type_ "button" ! A.onclick "login()"! A.class_ "button buttonBlue" $ "Login"
                H.button ! A.type_ "button" ! A.onclick "window.location.href='/register'"! A.class_ "button buttonGreen" $ "Register"

viewDashboard :: [Entity Member] -> [Entity Member] -> H.Html
viewDashboard membersList readyMembersList = do
    H.head $ do
        getMenuBarHeader
        H.link ! A.rel "stylesheet" ! A.href "/css/login.css"
        H.script ! A.src "https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js" ! A.type_ "text/javascript" $ ""
        H.script ! A.src "/js/login.js" ! A.type_ "text/javascript" $ ""
    H.body $ do
        H.div ! A.class_  "mdl-layout mdl-js-layout mdl-layout--fixed-drawer" $ do
            getMenuBarBody
            H.hgroup $ do
                H.h3 "Dashboard"
            H.form ! A.class_ "dashboardForm" $ do
                H.div ! A.class_ "mdl-grid" $ do
                    H.div ! A.class_ "mdl-cell mdl-cell--6-col graybox" $ do
                        H.div ! A.class_ "square-card mdl-card mdl-shadow--2dp" $ do
                            H.div ! A.class_ "mdl-card__title" $ do
                                H.h2 ! A.class_ "mdl-card__title-text" $ do
                                    H.h4 "Anzahl Atemschutzgeräteträger"
                            H.div ! A.class_ "mdl-card__supporting-text" $ do
                                    H.h5 $  toHtml (L.length membersList)
                    H.div ! A.class_ "mdl-cell mdl-cell--6-col graybox" $ do
                        H.div ! A.class_ "square-card mdl-card mdl-shadow--2dp" $ do
                            H.div ! A.class_ "mdl-card__title" $ do
                                H.h2 ! A.class_ "mdl-card__title-text" $ do
                                    H.h4 "Einsatzbereite Geräteträger"
                            H.div ! A.class_ "mdl-card__supporting-text" $ do
                                H.h5 $ toHtml (L.length readyMembersList)
                H.div ! A.class_ "mdl-grid" $ do
                    H.div ! A.class_ "mdl-cell mdl-cell--6-col graybox" $ do
                        H.div ! A.class_ "square-card mdl-card mdl-shadow--2dp nextAppointmentCard" $ do
                            H.div ! A.class_ "mdl-card__title" $ do
                                H.h2 ! A.class_ "mdl-card__title-text" $ do
                                    H.h4 "Nächster Termin"
                            H.div ! A.class_ "mdl-card__supporting-text" $ do
                                    H.h5 $ "Atemschutzübung"
                                    H.h5 $ "Am 25.02.2017"
