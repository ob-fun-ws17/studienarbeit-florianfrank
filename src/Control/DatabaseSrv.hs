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
-- | Module contains all databasefunctions
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

-- | Function to run all sql querys
runSQL :: (HasSpock m, SpockConn m ~ SqlBackend)  
    => SqlPersistT (NoLoggingT (ResourceT IO)) a
    -> m a
runSQL action =
    runQuery $ \conn ->
        runResourceT $ runNoLoggingT $ runSqlConn action conn
{-# INLINE runSQL #-}


-- | add user to database
registerUser = do
    maybeLogin <- jsonBody :: ApiAction ctx (Maybe Login)
    case maybeLogin of
        Nothing -> errorJson 1 "Failed to parse request body as Login Data"
        Just login -> do
            newId <- runSQL $ insert login
            json $ object ["result" .= String "success", "id" .= newId]


-- | set insert sessionKey into database
loginUser = do
    maybeLogin <- jsonBody :: ApiAction ctx (Maybe Login)
    case maybeLogin of
        Nothing -> errorJson 2 "No Logindata received"
        Just Login{loginMail = m, loginPassword = p}-> do
             maybeLoginDB <- runSQL $ P.getBy (UniqueLogin  m p)
             case maybeLoginDB of
                Nothing -> errorJson 2 "Could not find a person with matching id"
                Just loginDB -> do
                    runSQL $ insert $ Session 0
                    json loginDB


-- | remove sessionkey
logoutUser = do
    maybeSessionKey <- jsonBody ::ApiAction ctx (Maybe Session)
    case maybeSessionKey of
        Nothing -> errorJson 2 "No Session Key received"
        Just Session{sessionKey = sk} -> do
            sessionID <- runSQL $ P.deleteBy (UniqueSession sk)
            json $ object ["result" .= String "success", "id" .= sessionID]


-- | Function to add members to database
addMember = do
    maybeMember <- jsonBody :: ApiAction ctx (Maybe Member)
    case maybeMember of
        Nothing -> errorJson 1 "Failed to parse request body as Member Data"
        Just member -> do
            newId <- runSQL $ insert member
            json $ object ["result" .= String "success", "id" .= newId]


-- | Get all members from database
getMembers = do
    maybeTest <- jsonBody :: ApiAction ctx (Maybe Member)
    members <- runSQL $ P.selectList [] [Asc MemberName]
    json members


-- | Delete member from database
deleteMembers = do
    maybeMembers <- jsonBody ::ApiAction ctx (Maybe Memberlist)
    case maybeMembers of
        Nothing -> errorJson 1 "Failed to parse request body as Member Data"
        Just Memberlist{memberlistMembers = m} -> do
            deleteMembers' m


-- | recursive helperfunction to delete members
deleteMembers' (x:xs) = do
    selectAndDeleteMembers (x)
    deleteMembers' (xs)


-- | recursive helperfunction end
deleteMembers' [] = text ""


-- | Select and delete member by name, surname, birthDay, birthMonth, birthYear
selectAndDeleteMembers (Member n sn bd bm by _ _ _ _ _) = do
    newId <- runSQL $ P.deleteBy (UniqueMember n sn bd bm by)
    json $ object ["result" .= String "success", "id" .= newId]


-- | Function to add appointment to database
addAppointment = do
    maybeAppointment <- jsonBody :: ApiAction ctx (Maybe Appointment)
    case maybeAppointment of
        Nothing -> errorJson 1 "Failed to parse request body as Member Data"
        Just appointment -> do
            newId <- runSQL $ insert appointment
            json $ object ["result" .= String "success", "id" .= newId]


-- | Function to delete appointment from database
deleteAppointments = do
    maybeAppointment <- jsonBody ::ApiAction ctx (Maybe Appointmentlist)
    case maybeAppointment of
        Nothing -> errorJson 1 "Failed to parse request body as Member Data"
        Just Appointmentlist{appointmentlistAppointments = a} -> do
            deleteAppointments' a


-- | delete appointments recursion helper function
deleteAppointments' (x:xs) = do
    selectAndDeleteAppointments (x)
    deleteAppointments' (xs)


-- | delete appointments end of recursion
deleteAppointments' [] = text ""


-- | select appointment by title, tpye, day month, year an hour
selectAndDeleteAppointments (Appointment ti ty d mo y h mi me) = do
    newId <- runSQL $ P.deleteBy (UniqueAppointment ti d mo y h)
    json $ object ["result" .= String "success", "id" .= newId]


-- | udpate members
updateMembers = do
    maybeMemberUpdate <- jsonBody ::ApiAction ctx (Maybe Membersupdate)
    case maybeMemberUpdate of
        Nothing -> errorJson 1 "Failed to parse request body to update Members"
        Just Membersupdate{membersupdateType = t, membersupdateMemberSurNames = sn, membersupdateMemberNames = mn} -> do
            updateMembers' t sn mn


-- | Helperfunction to update member
updateMembers' ty (x:xs) (x2:x2s)= do
    updateMembers'' ty (x, x2)
    updateMembers' ty xs x2s


-- | Helpfunction to update member
updateMembers'' ty (membersurname, membername) =
        if (ty == "Übung" || ty == "Einsatz") then do
            newID <- runSQL $ P.updateWhere [MemberName ==. membername, MemberSurName ==. membersurname] [MemberExerciseCheck =. 1]
            json $ object ["result" .= String "success", "id" .= newID]
        else if (ty == "Unterweisung") then do
            newID <- runSQL $ P.updateWhere [MemberName ==. membername, MemberSurName ==. membersurname] [MemberInstructionCheck =. 1]
            json $ object ["result" .= String "success", "id" .= newID]
        else errorJson 1 "Failed to parse request body to update Members"


-- | Return JSON error code
errorJson :: Int        -- ^ Errorcode
    -> T.Text           -- ^ Errormessage
    -> ApiAction ctx a  -- ^ Return Spockaction
errorJson code message =
  json $
    object
    [ "result" .= String "failure"
    , "error" .= object ["code" .= code, "message" .= message]
    ]
