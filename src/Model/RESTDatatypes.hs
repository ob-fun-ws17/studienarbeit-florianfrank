{-# LANGUAGE EmptyDataDecls             #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE TypeFamilies               #-}
-- | Module contains all datatypes used by the REST service and functions to parse all ready members and strings
module Model.RESTDatatypes where

import           Database.Persist.TH
import qualified Data.Text as T
import Data.List as L
import Data.Time.Clock
import Data.Time.Calendar
import Database.Persist.Sqlite hiding (get)

-- | All REST Datatypes which can be packed into json und unpacked
share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|

-- | contains the logindata can be packed and unpacked to json
Login json -- The json keyword will make Persistent generate sensible ToJSON and FromJSON instances for us.
  mail                          T.Text
  password                      T.Text
  UniqueLogin                   mail password
  deriving Show

-- | contains the session key can be packed and unpacked to json
Session json
  key                           Int
  UniqueSession                 key

-- | contains the data of a member can be packed and unpacked to json
Member json
  name                          T.Text
  surName                       T.Text
  birthDay                      Int
  birthMonth                    Int
  birthYear                     Int
  examationDay                  Int
  examationMonth                Int
  examationYear                 Int
  instructionCheck              Int
  exerciseCheck                 Int
  UniqueMember                  name surName birthDay birthMonth birthYear

-- | A list of members can be packed and unpacked to json
Memberlist json
  members                       [Member]

-- | Object to update member can be packed and unpacked to json
Membersupdate json
  type                          T.Text
  memberSurNames                [T.Text]
  memberNames                   [T.Text]

-- | Appointmentobject can be packed and unpacked to json
Appointment json
  title                         T.Text
  type                          T.Text
  day                           Int
  month                         Int
  year                          Int
  hour                          Int
  minute                        Int
  members                       [T.Text]
  UniqueAppointment             title day month year hour
Appointmentlist json
  appointments                  [Appointment]
|]


-- | Get Current Time in (Year, Month, Day)
localTime :: IO (Integer, Int, Int)  -- ^ Do IO Return current Date
localTime = do
    now <- getCurrentTime
    let(year, month, day) = toGregorian $ utctDay now
    return (year, month, day)


-- | Get Return Members which joined all importend appointments
membersReady :: [Entity Member] -- ^ List of Members
    -> (Integer, Int, Int)      -- ^ Current Date
    -> [Entity Member]          -- ^ Return Members which joined all importend appointments
membersReady memberList (currYear, currMonth, currDay) = do
    L.filter (\x -> membersReadyFilter x (currDay, currMonth, toInteger currYear)) memberList


-- | Get members which joined all importend appointments
membersReadyList :: [Entity Member]
    -> (Integer, Int, Int)
    -> [Bool]
membersReadyList  memberList (currYear, currMonth, currDay) = do
    map (\x -> membersReadyFilter x (currDay, currMonth, toInteger currYear)) memberList


-- | Get appointments in Future
appointmentsInFuture :: [Entity Appointment] -- ^ List of Appointments
    -> (Integer, Int, Int)                   -- ^ Current Date
        -> [Entity Appointment]              -- ^ Appointments in future
appointmentsInFuture appointmentList (currYear, currMonth, currDay) = do
   L.filter (\x -> appointmentInFuture x (currDay, currMonth, toInteger currYear)) appointmentList


-- | Check if appointment is in future
appointmentInFuture :: Entity Appointment -- ^ Appointment to check
    -> (Int, Int, Integer)                -- ^ Current Date
    -> Bool                               -- ^ Flag if date is in future
appointmentInFuture a (currDay, currMonth, currYear) = do
   let year = toInteger (appointmentYear (entityVal a))
   let month = (appointmentMonth (entityVal a))
   let day = (appointmentDay (entityVal a))

   if (currYear > year) then
       False
   else if (currYear == year && currMonth > month) then
       False
   else if (currYear == year && currMonth == month && currDay >= day) then
       False
   else True


-- | Check if member joined all importend appointments
membersReadyFilter :: Entity Member  -- ^ Member
    -> (Int, Int, Integer)           -- ^ Current Date
    -> Bool                          -- ^ Flag if member is ready
membersReadyFilter a (currDay, currMonth, currYear) = do
  let year = toInteger (memberExamationYear (entityVal a))
  let month = (memberExamationMonth (entityVal a))
  let day = (memberExamationDay (entityVal a))
  let instCheck = (memberInstructionCheck (entityVal a))
  let exerCheck = (memberExerciseCheck (entityVal a))

  if (currYear > year) then
      False
  else if (currYear == year && currMonth > month) then
      False
  else if (currYear == year && currMonth == month && currDay >= day) then
      False
  else
      if (instCheck == 1 && exerCheck == 1)
          then True
      else False


-- | Convert Date to String
dateToString :: (Int, Int, Int) -- ^ Date to convert
    -> String                   -- ^ return converted date
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


-- | Convert Time to String
timeToString :: (Int, Int)  -- ^ Time to convert
    -> String               -- ^ Converted time
timeToString (h, m) = str where
       hour =
           if h < 10 then
               "0" ++ show h
           else show h
       minute =
           if m < 10 then
               "0" ++ show m
           else show m
       str = hour++":"++minute
