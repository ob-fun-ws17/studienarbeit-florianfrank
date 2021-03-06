{-# LANGUAGE OverloadedStrings          #-}
-- | Module starts Web and Restserice such as the Databaseserver
module Control.App
    (parseConfig, init_view, app) where

-- import internal Datatypes
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
import Web.Views.NoSessionKey

-- import external Datatypes
import                  Web.Spock.Config
import                  Web.Spock hiding (SessionId)
import                  Control.Monad.Trans
import                  Data.Monoid
import                  Network.Wai.Middleware.Static
import                  Text.Blaze.Html (Html, toHtml)
import                  Text.Blaze.Html.Renderer.Utf8 (renderHtml)
import                  Control.Monad.Logger    (LoggingT, runStdoutLoggingT)
import qualified        Database.Persist        as P         -- We'll be using P.get later for GET /people/<id>.
import                  Database.Persist.Sqlite hiding (get)
import qualified        Data.Configurator as C


-- | Initalizes the Spock server
init_view :: Config -- ^ Configuration of the Server
    -> IO ()        -- ^ Do IO
init_view cfg =
    do pool <- runStdoutLoggingT $ createSqlitePool (db_name cfg) 5
       spockCfg <- defaultSpockCfg Nothing (PCPool pool) (State cfg)
       runSpock (app_port cfg) $ spock spockCfg app


-- | Parses the config file
parseConfig :: FilePath -- ^ path of the config file
    -> IO Config        -- ^ Do IO return Config
parseConfig cfgFile =
   do cfg <- C.load [C.Required cfgFile]
      db <- C.require cfg "db"
      port <- C.require cfg "port"
      return (Config db port)


-- | Blaze HTML
blaze :: MonadIO m
    => Html                -- ^ HTML document to parse
    -> ActionCtxT ctx m a  -- ^ A spock action
blaze = lazyBytes . renderHtml
{-# INLINE blaze #-}


-- | Contains all functions of the spock server
app :: Api ()    -- ^ Return Api()
app =
    do middleware (staticPolicy (addBase "static"))
       get root $ do
           blaze $ viewLogin
       get "/home" $ do
           sessionKey <- runSQL $ P.getBy (UniqueSession 0)
           case sessionKey of
               Nothing -> blaze $ viewLogin
               Just session -> do
                   now <- liftIO $ localTime
                   members <- runSQL $ P.selectList [] [Asc MemberName]
                   appointments <- runSQL $ P.selectList [] [Asc AppointmentYear]
                   blaze $ viewDashboard members (membersReady members now) (appointmentsInFuture appointments now)
       get "/membermanagement" $ do
           sessionKey <- runSQL $ P.getBy (UniqueSession 0)
           case sessionKey of
               Nothing -> blaze $ viewNoSessionKey
               Just session -> do
                   now <- liftIO $ localTime
                   members <- runSQL $ P.selectList [] [Asc MemberName]
                   blaze $ viewMemberManagement members (membersReadyList members now)
       get "/appointmentmanagement" $ do
           sessionKey <- runSQL $ P.getBy (UniqueSession 0)
           case sessionKey of
               Nothing -> blaze $ viewNoSessionKey
               Just session -> do
                    appointments <- runSQL $ P.selectList [] [Asc AppointmentYear, Asc AppointmentMonth, Asc AppointmentYear]
                    blaze $ viewAppointmentManagement $ appointments
       get "/logout" $ do
            blaze $ viewLogout
       get "/impressum" $
            blaze $ viewImpressum
       get "/register" $ do
            runSQL $ runMigration migrateAll
            blaze $ viewRegister
       get "/addMember" $ do
           sessionKey <- runSQL $ P.getBy (UniqueSession 0)
           case sessionKey of
               Nothing -> blaze $ viewNoSessionKey
               Just session -> do
                   blaze $ viewAddMember
       get "/addAppointment" $ do
           sessionKey <- runSQL $ P.getBy (UniqueSession 0)
           case sessionKey of
               Nothing -> blaze $ viewNoSessionKey
               Just session -> do
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
           sessionKey <- runSQL $ P.getBy (UniqueSession 0)
           case sessionKey of
               Nothing -> blaze $ viewNoSessionKey
               Just session -> do
                   addMember
       post "addAppointment" $ do
           sessionKey <- runSQL $ P.getBy (UniqueSession 0)
           case sessionKey of
               Nothing -> blaze $ viewNoSessionKey
               Just session -> do
                   addAppointment
       post "deleteMember" $ do
           sessionKey <- runSQL $ P.getBy (UniqueSession 0)
           case sessionKey of
               Nothing -> blaze $ viewNoSessionKey
               Just session -> do
                   deleteMembers
       post "deleteAppointment" $ do
           sessionKey <- runSQL $ P.getBy (UniqueSession 0)
           case sessionKey of
               Nothing -> blaze $ viewNoSessionKey
               Just session -> do
                   deleteAppointments
       post "updateMember" $ do
           sessionKey <- runSQL $ P.getBy (UniqueSession 0)
           case sessionKey of
               Nothing -> blaze $ viewNoSessionKey
               Just session -> do
                   updateMembers
       post "logoutUser" $ do
           sessionKey <- runSQL $ P.getBy (UniqueSession 0)
           case sessionKey of
               Nothing -> blaze $ viewNoSessionKey
               Just session -> do
                   logoutUser
