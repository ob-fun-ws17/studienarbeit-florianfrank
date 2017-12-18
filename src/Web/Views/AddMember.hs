{-# LANGUAGE OverloadedStrings #-}
module Web.Views.AddMember where

import Web.Views.Home

import Control.Monad (forM_)
import Text.Blaze.XHtml5 ((!))
import qualified Text.Blaze.Bootstrap as H
import Text.Blaze.Html5 as H
import Text.Blaze.Html5.Attributes as A
import Text.Blaze.Html (Html, toHtml)


viewAddMember :: H.Html
viewAddMember = docTypeHtml $ do
    H.head $ do
        getMenuBarHeader
        H.link ! A.rel "stylesheet" ! A.href "/css/addmember.css"
        H.link ! A.rel "stylesheet" ! A.href  "/css/jquery/jquery-ui.css"

        H.script ! A.src "https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js" ! A.type_ "text/javascript" $ ""
        H.script ! A.src "/js/addmember.js" ! A.type_ "text/javascript" $ ""
        H.script ! A.src "https://code.jquery.com/jquery-1.12.4.js" ! A.type_ "text/javascript" $ ""
        H.script ! A.src "https://code.jquery.com/ui/1.12.1/jquery-ui.js" ! A.type_ "text/javascript" $ ""
        H.script "$( function() {$( '#datepicker' ).datepicker();} );"
    H.body $ do
        H.div ! A.class_  "mdl-layout mdl-js-layout mdl-layout--fixed-drawer" $ do
            getMenuBarBody
            H.hgroup $ do
                H.h3 "Add Member"
            H.form $ do
                H.div ! A.class_ "group" $ do
                    H.input ! A.type_ "text" ! A.id "name"
                    H.span ! A.class_ "highlight" $ ""
                    H.span ! A.class_ "bar" $ ""
                    H.label "Name"
                H.div ! A.class_ "group" $ do
                    H.input ! A.type_ "email" ! A.id "surname"
                    H.span ! A.class_ "highlight" $ ""
                    H.span ! A.class_ "bar" $ ""
                    H.label "Surname"
                H.div ! A.class_ "group" $ do
                    H.input ! A.type_ "text" ! A.id "datepicker"
                    H.span ! A.class_ "highlight" $ ""
                    H.label "Geburtsdatum"
                H.button ! A.type_ "button" ! A.onclick "addMember()" ! A.class_ "button buttonBlue" $ "Register"
