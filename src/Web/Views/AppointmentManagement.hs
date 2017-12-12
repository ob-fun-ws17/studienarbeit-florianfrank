{-# LANGUAGE OverloadedStrings #-}
module Web.Views.AppointmentManagement where

import Web.Views.Home
import Text.Blaze.Html5 as H
import Text.Blaze.Html5.Attributes as A
import qualified Data.Text as T

import Web.Views.Home

viewAppointments :: H.Html
viewAppointments = docTypeHtml $ do
        H.head $ do
            getMenuBarHeader
        H.body $ do
            H.div ! A.class_  "mdl-layout mdl-js-layout mdl-layout--fixed-drawer" $ do
                getMenuBarBody
