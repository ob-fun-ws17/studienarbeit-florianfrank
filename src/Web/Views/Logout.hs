{-# LANGUAGE OverloadedStrings #-}
-- | Module shows Logout view
module Web.Views.Logout
    (viewLogout) where

-- import internal modules
import Web.Views.Home -- Home contains function to create menu

-- import external modules
import Text.Blaze.Html5 as H
import Text.Blaze.Html5.Attributes as A


-- | create logout html page
viewLogout :: H.Html    -- ^ html page
viewLogout = docTypeHtml $ do
    H.head $ do
        getMenuBarHeader
        H.link ! A.rel "stylesheet" ! A.href "/css/logout.css"
        H.script ! A.src "/js/logout.js" ! A.type_ "text/javascript" $ ""
    H.body ! A.onload "logoutUser()" $ do
        H.div ! A.class_  "mdl-layout mdl-js-layout mdl-layout--fixed-drawer" $ do
            getMenuBarBody
            H.hgroup $ do
                H.form $ do
                    H.h3 $ do
                        H.a ! A.href "/home" $ "Zurück zur Startseite"
