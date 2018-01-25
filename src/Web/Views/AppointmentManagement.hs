{-# LANGUAGE OverloadedStrings #-}
-- | Module shows AppointmentManagement
module Web.Views.AppointmentManagement
    (viewAppointmentManagement, viewTableHead, viewTableBody) where

-- import internal modules
import              Web.Views.Home -- Home contains function to create menu
import              Model.RESTDatatypes

-- import external modules
import              Text.Blaze.Html5 as H
import              Text.Blaze.Html5.Attributes as A
import qualified    Data.Text as T
import              Database.Persist (Entity(..))


-- | create AppointmentManagement HTML page
viewAppointmentManagement :: [Entity Appointment]   -- ^ all appointments
    -> H.Html                                       -- ^ html page
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


-- | create table body html element
viewTableHead :: H.Html  -- ^ html page
viewTableHead =
            H.thead $ do
                H.th ! A.class_ "mdl-data-table__cell--non-numeric" $ "Titel"
                H.th  "Typ"
                H.th  "Datum"
                H.th  "Uhrzeit"
                H.th  "Teilnehmer"


-- | recursive table body helper function
viewTableBody :: [Entity Appointment]    -- ^ all appointments
    -> H.Html                            -- ^ html page
viewTableBody mem = H.tbody $ do
        viewTableBody' (mem)


-- | recursive table body helper function
viewTableBody' :: [Entity Appointment]   -- ^ all appointments
    -> H.Html                            -- ^ html page
viewTableBody' (x:xs) = do
        H.tr $ do
            H.td ! A.class_ "mdl-data-table__cell--non-numeric" $ toHtml (appointmentTitle (entityVal x))
            H.td $ toHtml (appointmentType (entityVal x))
            H.td $ toHtml (dateToString ((appointmentMonth (entityVal x)), (appointmentDay (entityVal x)), (appointmentYear (entityVal x)))) ! A.class_ "td"
            H.td $ toHtml (timeToString ((appointmentHour (entityVal x)), (appointmentMinute (entityVal x))))
            H.td $ (membersToString (appointmentMembers (entityVal x)))
        viewTableBody' (xs)

-- | recursive table body helper function
viewTableBody' [] = H.h1 ""


-- | convert list of members to a single string
membersToString :: [T.Text]  -- ^ members to convert
    -> H.Html                -- ^ html page
membersToString (x:xs) = do
        H.pre $  toHtml x
        membersToString(xs)


-- | recursive name to string helper function
membersToString [] = H.h1 ""
