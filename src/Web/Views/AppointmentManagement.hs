{-# LANGUAGE OverloadedStrings #-}
module Web.Views.AppointmentManagement where

import Web.Views.Home
import Model.RESTDatatypes
import Text.Blaze.Html5 as H
import Text.Blaze.Html5.Attributes as A
import Data.List as L
import qualified Data.Text as T
import           Database.Persist        hiding (get) -- To avoid a naming clash with Web.Spock.get
import qualified Database.Persist        as P         -- We'll be using P.get later for GET /people/<id>.
import           Database.Persist.Sqlite hiding (get)
import           Database.Persist.TH


viewAppointmentManagement :: [Entity Appointment] -> H.Html
viewAppointmentManagement members = do
    docTypeHtml $ do
        H.head $ do
            getMenuBarHeader
            H.link ! A.rel "stylesheet" ! A.href "/css/appointmentmanagement.css"
            H.script ! A.src "/js/appointmentmanagement.js" ! A.type_ "text/javascript" $ ""
            H.script ! A.src "https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js" ! A.type_ "text/javascript" $ ""
            H.meta ! A.charset "UTF-8"
        H.body $ do
            H.div ! A.class_  "mdl-layout mdl-js-layout mdl-layout--fixed-drawer" $ do
                H.hgroup $ do
                    H.form $ do
                        H.h3 "Termine"
                        H.button ! A.type_ "button" ! A.onclick "window.location.href='/addAppointment'"! A.class_ "button buttonGreen" $ "Termin hinzufügen"
                        H.button !A.type_ "button" ! A.onclick "deleteAppointment()" ! A.class_ "button buttonBlue" $ "Löschen"
                        H.table ! A.class_ "mdl-data-table mdl-js-data-table mdl-data-table--selectable mdl-shadow--2dp width" ! A.id "appointmentTable" $ do
                            viewTableHead
                            viewTableBody members
                        --H.div ! A.id "procesbar1" ! A.style "width:820px" !  A.class_ "mdl-progress mdl-js-progress mdl-progress__indeterminate" $ ""
                getMenuBarBody


viewTableHead :: H.Html
viewTableHead =
            H.thead $ do
                H.th ! A.class_ "mdl-data-table__cell--non-numeric" $ "Titel"
                H.th  "Typ"
                H.th  "Datum"
                H.th  "Uhrzeit"
                H.th  "Teilnehmer"

viewTableBody :: [Entity Appointment] -> H.Html
viewTableBody mem = H.tbody $ do
        viewTableBody' (mem)

viewTableBody' :: [Entity Appointment] -> H.Html
viewTableBody' (x:xs) = do
        H.tr $ do
            H.td ! A.class_ "mdl-data-table__cell--non-numeric" $ toHtml (appointmentTitle (entityVal x))
            H.td $ toHtml (appointmentType (entityVal x))
            H.td $ toHtml (dateToString ((appointmentDay (entityVal x)), (appointmentMonth (entityVal x)), (appointmentYear (entityVal x)))) ! A.class_ "td"
            H.td $ toHtml (timeToString ((appointmentHour (entityVal x)), (appointmentMinute (entityVal x))))
            H.td $ (membersToString (appointmentMembers (entityVal x)))
        viewTableBody' (xs)

viewTableBody' [] = H.h1 ""

membersToString :: [T.Text] -> H.Html
membersToString (x:xs) = do
        H.pre $  toHtml x
        membersToString(xs)

membersToString [] = H.h1 ""

dateToString :: (Int, Int, Int) -> String
dateToString (d, m, y) = str where
                 day  =
                     if d < 10 then
                         "0" ++ show d
                     else
                          show d
                 month =
                     if m < 10 then
                         "0" ++ show m
                     else
                         show m

                 str = day ++ "." ++ month ++ "." ++ show y


timeToString :: (Int, Int) -> String
timeToString (h, m) = str where
        hour =
            if h < 10 then
                "0" ++ show h
            else show h
        minute =
            if m < 10 then
                "0" ++ show m
            else show m
        str = hour++":"++minute
