{-# LANGUAGE OverloadedStrings #-}
-- | Module shows AddMember view
module Web.Views.AddMember
    (viewAddMember) where

-- import internal modules
import Web.Views.Home -- Home contains function to create menu

-- import external modules
import Text.Blaze.Html5 as H
import Text.Blaze.Html5.Attributes as A


-- | create addMember Html Page
viewAddMember :: H.Html -- ^ html element
viewAddMember = docTypeHtml $ do
    H.head $ do
        getMenuBarHeader
        H.link ! A.rel "stylesheet" ! A.href "/css/addmember.css"
        H.link ! A.rel "stylesheet" ! A.href  "/css/jquery/jquery-ui.css"

        H.script ! A.src "https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js" ! A.type_ "text/javascript" $ ""
        H.script ! A.src "/js/addmember.js" ! A.type_ "text/javascript" $ ""
        H.script ! A.src "https://code.jquery.com/jquery-1.12.4.js" ! A.type_ "text/javascript" $ ""
        H.script ! A.src "https://code.jquery.com/ui/1.12.1/jquery-ui.js" ! A.type_ "text/javascript" $ ""
        H.script "$( function() {$( '#datepickerBirthD' ).datepicker();} );"
        H.script "$( function() {$( '#datepickerExamation' ).datepicker();} );"
    H.body $ do
        H.div ! A.class_  "mdl-layout mdl-js-layout mdl-layout--fixed-drawer" $ do
            getMenuBarBody
            H.hgroup $ do
                H.h3 "Mitglied hinzufügen"
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
                    H.input ! A.type_ "text" ! A.id "datepickerBirthD"
                    H.span ! A.class_ "highlight" $ ""
                    H.label "Geburtsdatum"
                H.div ! A.class_ "group" $ do
                    H.input ! A.type_ "text" ! A.id "datepickerExamation"
                    H.span ! A.class_ "highlight" $ ""
                    H.label "nächster Untersuchtungstermin"
                H.button ! A.type_ "button" ! A.onclick "addMember()" ! A.class_ "button buttonBlue" $ "Mitglied hinzufügen"
                H.button ! A.type_ "button" ! A.onclick "window.location.href='/membermanagement'" ! A.class_ "button buttonGreen" $ "Zurück"
