{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE EmptyDataDecls             #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE TypeFamilies               #-}
module Control.App where

import Model.RESTDatatypes
import Model.Config
import Control.DatabaseSrv
import Web.Views.Home
import Web.Views.AppointmentManagement
import Web.Views.MemberManagement
import Web.Views.Impressum
import Web.Views.Register
import Web.Views.Logout
import Web.Views.AddMember
import Web.Views.AddAppointment

import Web.Spock
import Web.Spock.Config
import Web.Spock hiding (SessionId)

import Control.Monad.Trans
import Control.Monad.Trans.Resource
import Control.Monad.Logger
import Data.Monoid
import Network.Wai.Middleware.Static
import Text.Blaze.Html (Html, toHtml)
import Text.Blaze.Html.Renderer.Utf8 (renderHtml)
import Data.IORef
import           Data.Aeson       hiding (json)
import           GHC.Generics
import qualified Data.Text as T

import           Control.Monad.Logger    (LoggingT, runStdoutLoggingT)
import           Database.Persist        hiding (get) -- To avoid a naming clash with Web.Spock.get
import qualified Database.Persist        as P         -- We'll be using P.get later for GET /people/<id>.
import           Database.Persist.Sqlite hiding (get)
import           Database.Persist.TH
import qualified Data.Configurator as C


init_view :: Config -> IO ()
init_view cfg =
    do pool <- runStdoutLoggingT $ createSqlitePool (db_name cfg) 5
       spockCfg <- defaultSpockCfg Nothing (PCPool pool) (State cfg)
       runSpock (app_port cfg) $ spock spockCfg app


parseConfig :: FilePath -> IO Config
parseConfig cfgFile =
   do cfg <- C.load [C.Required cfgFile]
      db <- C.require cfg "db"
      port <- C.require cfg "port"
      return (Config db port)

blaze :: MonadIO m => Html -> ActionCtxT ctx m a
blaze = lazyBytes . renderHtml
{-# INLINE blaze #-}

app :: Api ()
app =
    do middleware (staticPolicy (addBase "static"))
       get root $
            blaze $ viewHome
       get "/home" $
            blaze $ viewHome
       get "/membermanagement" $ do
           members <- runSQL $ P.selectList [] [Asc MemberName]
           blaze $ viewMemberManagement $ members
       get "/appointmentmanagement" $ do
            appointments <- runSQL $ P.selectList [] [Asc AppointmentTitle]
            blaze $ viewAppointmentManagement $ appointments
       get "/logout" $
            blaze $ viewLogout
       get "/impressum" $
            blaze $ viewImpressum
       get "/register" $
            blaze $ viewRegister
       get "/addMember" $
            blaze $ viewAddMember
       get "/addAppointment" $ do
            members <- runSQL $ P.selectList [] [Asc MemberName]
            blaze $ addAppointmentView members
        -- REST API --
       get "createTable" $
            runSQL $ runMigration migrateAll
       post "register" $ do
           registerUser
       post "login" $ do
           loginUser
       post "addMember" $ do
            addMember
       post "addAppointment" $ do
            addAppointment
