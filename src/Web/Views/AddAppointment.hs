{-# LANGUAGE OverloadedStrings #-}
module Web.Views.AddAppointment where

import Web.Views.Home
import Model.RESTDatatypes

import Text.Blaze.Html5 as H
import Text.Blaze.Html5.Attributes as A
import qualified Data.Text as T
import           Database.Persist        hiding (get) -- To avoid a naming clash with Web.Spock.get
import qualified Database.Persist        as P         -- We'll be using P.get later for GET /people/<id>.
import           Database.Persist.Sqlite hiding (get)
import           Database.Persist.TH

addAppointmentView :: [Entity Member] -> H.Html
addAppointmentView members = docTypeHtml $ do
    H.head $ do
        getMenuBarHeader

        H.script ! A.src "https://cdnjs.cloudflare.com/ajax/libs/jquery/2.2.2/jquery.min.js" ! A.type_ "text/javascript" $ ""
        H.script ! A.src "/js/addappointment.js" ! A.type_ "text/javascript" $ ""
        H.script ! A.src "https://code.jquery.com/jquery-1.12.4.js" ! A.type_ "text/javascript" $ ""
        H.script ! A.src "https://code.jquery.com/ui/1.12.1/jquery-ui.js" ! A.type_ "text/javascript" $ ""
        H.link ! A.rel "stylesheet" ! A.href "/css/addappointment.css"
        H.link ! A.rel "stylesheet" ! A.href  "/css/jquery/jquery-ui.css"
        H.link ! A.rel "stylesheet prefetch" ! A.href "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"
        H.script "$( function() {$( '#datepicker' ).datepicker();} );"
        H.script ! A.src "/js/addappointment.js" ! A.type_ "text/javascript" $ ""
    H.body $ do
        H.div ! A.class_  "mdl-layout mdl-js-layout mdl-layout--fixed-drawer" $ do
            getMenuBarBody
            H.hgroup $ do
                H.h3 "Termin hinzufügen"
            H.form $ do
                H.div ! A.class_ "group" $ do
                    H.input ! A.type_ "text" ! A.id "mail"
                    H.span ! A.class_ "highlight" $ ""
                    H.span ! A.class_ "bar" $ ""
                    H.label "Title"
                H.div ! A.class_ "mdl-textfield mdl-js-textfield mdl-textfield--floating-label getmdl-select getmdl-select__fullwidth" $ do
                    H.input ! A.class_ "mdl-textfield__input" ! A.type_ "text" ! A.id "type" ! A.value ""
                    H.label ! A.for "type" ! A.class_ "mdl-textfield__label" $ ""
                    H.ul ! for "type" ! A.class_ "mdl-menu mdl-menu--bottom-left mdl-js-menu" $ do
                        H.li ! A.class_ "mdl-menu__item" $ "Übung"
                        H.li ! A.class_ "mdl-menu__item" $ "Einsatz"
                        H.li ! A.class_ "mdl-menu__item" $ "Untersuchtung"
                        H.li ! A.class_ "mdl-menu__item" $ "Übungsanlage"
                    H.label "Typ"
                H.div ! A.class_ "group" $ do
                    H.input ! A.type_ "text" ! A.id "datepicker"
                    H.span ! A.class_ "highlight" $ ""
                    H.label "Datum"
                H.section $ do
                    H.div ! A.id "container" $ do
                        H.label "Mitglieder auswählen"
                        H.div ! A.class_ "row addremove-multiselect" $ do
                            H.div ! A.class_ "col-lg-5 col-sm-5 col-xs-12" $ do
                                H.div ! A.class_ "panel panel-default" $ do
                                    H.div ! A.class_ "panel-heading" $ "Mitglieder"
                                    H.div ! A.class_ "panel-body" $ do
                                        H.select ! A.id "available-select" ! A.class_ "multiselect availbable form-control" ! A.size "8" ! A.multiple "multiple" $ do
                                            addMemberMultiselect members

                            H.div ! A.class_ "multiselect-controls col-lg-2 col-sm-2 col-xs-12" $ do
                                H.button ! A.type_ "button" ! A.id "right" ! A.class_ "right btn btn-block" $
                                    H.i ! A.class_ "glyphicon glyphicon-chevron-right" $ ""
                                H.button ! A.type_ "button" ! A.id "left" ! A.class_ "left btn btn-block" $
                                    H.i ! A.class_ "glyphicon glyphicon-chevron-left" $ ""

                            H.div ! A.class_ "col-lg-5 col-sm-5 col-xs-12" $ do
                                H.div ! A.class_ "panel panel-default" $ do
                                    H.div ! A.class_ "panel-heading" $ "Ausgewählte Mitglieder"
                                    H.div ! A.class_ "panel-body" $
                                        H.select ! A.id "selected-select" ! A.class_ "multiselect selected form-control" ! A.size "8" ! A.multiple "multiple" $ ""

                H.button ! A.type_ "button" ! A.onclick "addAppointment()" ! A.class_ "button buttonBlue" $ "Hinzufügen"
                H.button ! A.type_ "button" ! A.onclick "window.location.href='/appointmentmanagement'" ! A.class_ "button buttonGreen" $ "Zurück"


addMemberMultiselect :: [Entity Member] -> H.Html
addMemberMultiselect member = H.tbody $ do
    addMemberMultiselect' (member)

addMemberMultiselect' :: [Entity Member] -> H.Html
addMemberMultiselect' (x: xs) = do
    H.option ! A.value (stringValue (nameToString (memberName (entityVal x), memberSurName (entityVal x)))) $ (toHtml (nameToString (memberName (entityVal x), memberSurName (entityVal x))))
    addMemberMultiselect' (xs)

addMemberMultiselect' [] = H.h1 ""


nameToString:: (T.Text, T.Text) -> String
nameToString (a, b) = (show a) ++ " " ++ (show b)
