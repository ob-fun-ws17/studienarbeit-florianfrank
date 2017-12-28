{-# LANGUAGE OverloadedStrings #-}
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


viewMemberManagement :: [Entity Member] -> H.Html
viewMemberManagement members = do
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
                            viewTableBody members
                        --H.div ! A.id "procesbar1" ! A.style "width:820px" !  A.class_ "mdl-progress mdl-js-progress mdl-progress__indeterminate" $ ""
                getMenuBarBody


viewTableHead :: H.Html
viewTableHead =
            H.thead $ do
                H.th ! A.class_ "mdl-data-table__cell--non-numeric" $ "Vorname"
                H.th  "Name"
                H.th  "GeburtsDatum"
                H.th  "Nächster Untersuchtungstermin"
                H.th  "Unterweisung"
                H.th  "Einsatz/Übung"
                H.th  "Anforderungen Erfüllt"

viewTableBody :: [Entity Member] -> H.Html
viewTableBody mem = H.tbody $ do
        viewTableBody' (mem)

viewTableBody' :: [Entity Member] -> H.Html
viewTableBody' (x:xs) = do
        H.tr $ do
            H.td ! A.class_ "mdl-data-table__cell--non-numeric" $ toHtml (memberName (entityVal x))
            H.td $ toHtml (memberSurName (entityVal x)) ! A.class_ "td"
            H.td $ toHtml (dateToString ((memberBirthMonth (entityVal x)), (memberBirthDay (entityVal x)), (memberBirthYear (entityVal x))))
            H.td $ toHtml (dateToString ((memberExamationMonth (entityVal x)), (memberExamationDay (entityVal x)), (memberExamationYear (entityVal x))))
            H.td $ toHtml (memberInstructionCheck (entityVal x))
            H.td $ toHtml (memberExerciseCheck (entityVal x))
            H.td "vielleicht"
        viewTableBody' (xs)

viewTableBody' [] = H.h1 ""


dateToString :: (Int, Int, Int) -> String
dateToString (m, d, y) = str where
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
