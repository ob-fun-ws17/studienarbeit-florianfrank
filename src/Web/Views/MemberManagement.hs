{-# LANGUAGE OverloadedStrings #-}
-- | Module shows MemberManagement view
module Web.Views.MemberManagement where

import Web.Views.Home
import Model.RESTDatatypes
import Text.Blaze.Html5 as H
import Text.Blaze.Html5.Attributes as A
import Data.List as L
import           Database.Persist        hiding (get) -- To avoid a naming clash with Web.Spock.get
import qualified Database.Persist        as P         -- We'll be using P.get later for GET /people/<id>.
import           Database.Persist.Sqlite hiding (get)
import           Database.Persist.TH


-- | create MemberManagement html page
viewMemberManagement :: [Entity Member]   -- ^ members
    -> [Bool]                             -- ^ flag if member is ready
    -> H.Html                             -- ^ html page
viewMemberManagement members ready = do
    docTypeHtml $ do
        H.head $ do
            getMenuBarHeader
            H.link ! A.rel "stylesheet" ! A.href "/css/membermanagement.css"
            H.script ! A.src "/js/membermanagement.js" ! A.type_ "text/javascript" $ ""
            H.meta ! A.charset "UTF-8"
        H.body $ do
            H.div ! A.class_  "mdl-layout mdl-js-layout mdl-layout--fixed-drawer" $ do
                H.hgroup $ do
                    H.form $ do
                        H.h3 "Mitglieder"
                        H.button ! A.type_ "button" ! A.onclick "window.location.href='/addMember'"! A.class_ "button buttonGreen" $ "Mitglied hinzufügen"
                        H.button !A.type_ "button" ! A.onclick "deleteMember()" ! A.class_ "button buttonBlue" $ "Löschen"
                        H.table ! A.class_ "mdl-data-table mdl-js-data-table mdl-data-table--selectable mdl-shadow--2dp" ! A.id "memberTable" $ do
                            viewTableHead
                            viewTableBody members ready
                        --H.div ! A.id "procesbar1" ! A.style "width:820px" !  A.class_ "mdl-progress mdl-js-progress mdl-progress__indeterminate" $ ""
                getMenuBarBody


-- | create table head html element
viewTableHead :: H.Html  -- ^ html page
viewTableHead =
            H.thead $ do
                H.th ! A.class_ "mdl-data-table__cell--non-numeric" $ "Vorname"
                H.th  "Name"
                H.th  "GeburtsDatum"
                H.th  "Nächster Untersuchtungstermin"
                H.th  "Unterweisung"
                H.th  "Einsatz/Übung"
                H.th  "Anforderungen Erfüllt"

-- | create table body html element
viewTableBody :: [Entity Member]     -- ^ members
    -> [Bool]                        -- ^ ready members
    -> H.Html                        -- ^ html page
viewTableBody mem ready = H.tbody $ do
        viewTableBody' mem ready

-- | recursive table body helper function
viewTableBody' :: [Entity Member]   -- ^ members
    -> [Bool]                       -- ^ ready members
    -> H.Html                       -- ^ html page
viewTableBody' (x:xs) (ready: xready) = do
        H.tr $ do
            H.td ! A.class_ "mdl-data-table__cell--non-numeric" $ toHtml (memberSurName (entityVal x))
            H.td $ toHtml (memberName (entityVal x)) ! A.class_ "td"
            H.td $ toHtml (dateToString ((memberBirthMonth (entityVal x)), (memberBirthDay (entityVal x)), (memberBirthYear (entityVal x))))
            H.td $ toHtml (dateToString ((memberExamationMonth (entityVal x)), (memberExamationDay (entityVal x)), (memberExamationYear (entityVal x))))
            H.td $ if (memberInstructionCheck (entityVal x)) == 0 then text "Nein" else text "Ja"
            H.td $ if (memberExerciseCheck (entityVal x)) == 0 then text "Nein" else text "Ja"
            H.td $ if ready then text "Ja" else text "Nein"
        viewTableBody' xs xready


-- | recursive table body helper function
viewTableBody' [] [] = H.h1 ""
