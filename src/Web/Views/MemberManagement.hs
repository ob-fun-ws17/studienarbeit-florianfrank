{-# LANGUAGE OverloadedStrings #-}
module Web.Views.MemberManagement where

import Web.Views.Home
import Model.Member
import Text.Blaze.Html5 as H
import Text.Blaze.Html5.Attributes as A
import Data.List as L



viewMemberManagement :: [Member] -> H.Html
viewMemberManagement members= do
    docTypeHtml $ do
        H.head $ do
            getMenuBarHeader
            H.link ! A.rel "stylesheet" ! A.href "/css/membermanagement.css"
            H.meta ! A.charset "UTF-8"
        H.body $ do
            H.div ! A.class_  "mdl-layout mdl-js-layout mdl-layout--fixed-drawer" $ do
                H.hgroup $ do
                    H.form $ do
                        H.h3 "Mitglieder"
                        H.button ! A.type_ "addButton" ! A.class_ "addButton" $ "Mitglied hinzufügen"
                        H.button ! A.type_ "deleteButton" ! A.class_ "deleteButton" $ "Löschen"
                        H.table ! A.class_ "mdl-data-table mdl-js-data-table mdl-data-table--selectable mdl-shadow--2dp" $ do
                            viewTableHead
                            viewTableBody testMembers
                        H.div ! A.id "procesbar1" ! A.style "width:820px" !  A.class_ "mdl-progress mdl-js-progress mdl-progress__indeterminate" $ ""


                getMenuBarBody

viewTableHead :: H.Html
viewTableHead =
            H.thead $ do
                H.th ! A.class_ "mdl-data-table__cell--non-numeric" $ "Vorname"
                H.th  "Name"
                H.th  "Nächster Untersuchtungstermin"
                H.th  "GeburtsDatum"
                H.th  "Unterweisung"
                H.th  "Einsatz/Übung"
                H.th  "Anforderungen Erfüllt"

viewTableBody :: [Member] -> H.Html
viewTableBody mem = H.tbody $ do
        viewTableBody' (mem)

viewTableBody' :: [Member] -> H.Html
viewTableBody' (x:xs) = do
        H.tr $ do
            H.td ! A.class_ "mdl-data-table__cell--non-numeric" $ toHtml (getFirstName x)
            H.td $ toHtml (getSurName x) ! A.class_ "td"
            H.td $ toHtml (getBrithDayStr x)
            H.td $ toHtml (getNextExamationAppointmentStr x)
            H.td $ toHtml (getInstructionCheckStr x)
            H.td $ toHtml (getExerciseCheckStr x)
            H.td "vielleicht"
        viewTableBody' (xs)

viewTableBody' [] = H.h1 ""
