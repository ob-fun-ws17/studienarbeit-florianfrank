{-# LANGUAGE OverloadedStrings #-}
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

import Model.Member
import Web.Views.Home
import Web.Views.AppointmentManagement
import Web.Views.MemberManagement
import Web.Views.Impressum
import Web.Views.Register
import Web.Views.Logout

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

data State
   = State
   { bs_cfg :: Config
   }

data Config
   = Config
   { db_name   :: T.Text
   , app_port :: Int
   }

type SessionVal = Maybe SessionId
type Api ctx = SpockCtxM ctx SqlBackend SessionVal State ()
type ApiAction ctx a = SpockActionCtx ctx SqlBackend SessionVal State a

type Api' = SpockM SqlBackend () () ()
type ApiAction' a = SpockAction SqlBackend () () a

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
Login json -- The json keyword will make Persistent generate sensible ToJSON and FromJSON instances for us.
  mail T.Text
  password T.Text
  deriving Show
|]

init_view :: Config -> IO ()
init_view cfg =
    do pool <- runStdoutLoggingT $ createSqlitePool (db_name cfg) 5
       spockCfg <- defaultSpockCfg Nothing (PCPool pool) (State cfg)
       runSpock (app_port cfg) $ spock spockCfg app

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
       get "/membermanagement" $
            blaze $ viewMemberManagement testMembers
       get "/appointmentmanagement" $
            blaze $ viewAppointments
       get "/logout" $
            blaze $ viewLogout
       get "/impressum" $
            blaze $ viewImpressum
       get "/register" $
            blaze $ viewRegister
        -- REST API --
       post "register" $ do
            maybeLogin <- jsonBody :: ApiAction ctx (Maybe Login)
            case maybeLogin of
                Nothing -> errorJson 1 "Failed to parse request body as Login Data"
                Just login -> do
                    newId <- runSQL $ insert login
                    json $ object ["result" .= String "success", "id" .= newId]

       get ("people" <//> var) $ \email -> do
            maybeLogin <- runSQL $ P.get email :: ApiAction ctx (Maybe Login)
            case maybeLogin of
                Nothing -> errorJson 2 "Email not registered"
                Just login -> json login


runSQL :: (HasSpock m, SpockConn m ~ SqlBackend) => SqlPersistT (NoLoggingT (ResourceT IO)) a -> m a
runSQL action =
    runQuery $ \conn ->
        runResourceT $ runNoLoggingT $ runSqlConn action conn
{-# INLINE runSQL #-}

errorJson :: Int -> T.Text -> ApiAction ctx a
errorJson code message =
  json $
    object
    [ "result" .= String "failure"
    , "error" .= object ["code" .= code, "message" .= message]
    ]

parseConfig :: FilePath -> IO Config
parseConfig cfgFile =
    do cfg <- C.load [C.Required cfgFile]
       db <- C.require cfg "db"
       port <- C.require cfg "port"
       return (Config db port)
