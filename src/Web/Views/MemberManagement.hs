{-# LANGUAGE OverloadedStrings #-}
module Web.Views.MemberManagement where

import Web.Views.Home
import Text.Blaze.Html5 as H
import Text.Blaze.Html5.Attributes as A

viewMemberManagement :: H.Html
viewMemberManagement = docTypeHtml $ do
    H.head $ do
        getMenuBarHeader
    H.body $ do
        getMenuBarBody
