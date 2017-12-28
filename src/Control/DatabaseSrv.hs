{-# LANGUAGE EmptyDataDecls             #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE TypeFamilies               #-}
{-# LANGUAGE OverloadedStrings          #-}
module Control.DatabaseSrv where

import Model.RESTDatatypes
import Model.Config


import Web.Spock.Config
import Web.Spock


import           Control.Monad.Logger    (LoggingT, runStdoutLoggingT)
import           Database.Persist        hiding (get) -- To avoid a naming clash with Web.Spock.get
import qualified Database.Persist        as P         -- We'll be using P.get later for GET /people/<id>.
import           Database.Persist.Sqlite hiding (get)
import           Database.Persist.TH
import           Control.Monad.Logger
import           Control.Monad.Trans.Resource
import           Data.IORef
import           Data.Aeson       hiding (json)
import           GHC.Generics
import qualified Data.Text as T


runSQL :: (HasSpock m, SpockConn m ~ SqlBackend) => SqlPersistT (NoLoggingT (ResourceT IO)) a -> m a
runSQL action =
    runQuery $ \conn ->
        runResourceT $ runNoLoggingT $ runSqlConn action conn
{-# INLINE runSQL #-}


registerUser = do
    maybeLogin <- jsonBody :: ApiAction ctx (Maybe Login)
    case maybeLogin of
        Nothing -> errorJson 1 "Failed to parse request body as Login Data"
        Just login -> do
            newId <- runSQL $ insert login
            json $ object ["result" .= String "success", "id" .= newId]

loginUser = do
    maybeLogin <- jsonBody :: ApiAction ctx (Maybe Login)
    case maybeLogin of
        Nothing -> errorJson 2 "No Logindata received"
        Just Login{loginMail = m, loginPassword = p}-> do
             maybeLoginDB <- runSQL $ P.getBy (UniqueLogin  m p)
             case maybeLoginDB of
                Nothing -> errorJson 2 "Could not find a person with matching id"
                Just loginDB -> json loginDB


addMember = do
    maybeMember <- jsonBody :: ApiAction ctx (Maybe Member)
    case maybeMember of
        Nothing -> errorJson 1 "Failed to parse request body as Member Data"
        Just member -> do
            newId <- runSQL $ insert member
            json $ object ["result" .= String "success", "id" .= newId]

getMembers = do
    maybeTest <- jsonBody :: ApiAction ctx (Maybe Member)
    members <- runSQL $ P.selectList [] [Asc MemberName]
    json members

deleteMembers = do
    maybeMembers <- jsonBody ::ApiAction ctx (Maybe Memberlist)
    case maybeMembers of
        Nothing -> errorJson 1 "Failed to parse request body as Member Data"
        Just Memberlist{memberlistMembers = m} -> do
            deleteMembers' m

deleteMembers' (x:xs) = do
    selectAndDelete (x)
    deleteMembers' (xs)

deleteMembers' [] = text ""

selectAndDelete (Member n sn bd bm by _ _ _ _ _) = do
    newId <- runSQL $ P.deleteBy (UniqueMember n sn bd bm by)
    json $ object ["result" .= String "success", "id" .= newId]

addAppointment = do
    maybeAppointment <- jsonBody :: ApiAction ctx (Maybe Appointment)
    case maybeAppointment of
        Nothing -> errorJson 1 "Failed to parse request body as Member Data"
        Just appointment -> do
            newId <- runSQL $ insert appointment
            json $ object ["result" .= String "success", "id" .= newId]

errorJson :: Int -> T.Text -> ApiAction ctx a
errorJson code message =
  json $
    object
    [ "result" .= String "failure"
    , "error" .= object ["code" .= code, "message" .= message]
    ]
