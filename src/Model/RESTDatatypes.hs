{-# LANGUAGE EmptyDataDecls             #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE TypeFamilies               #-}
module Model.RESTDatatypes where

import           Database.Persist.TH
import qualified Data.Text as T
import Data.List as L
import Data.Time.Clock
import Data.Time.Calendar
import Database.Persist.Sqlite hiding (get)


share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
Login json -- The json keyword will make Persistent generate sensible ToJSON and FromJSON instances for us.
  mail                          T.Text
  password                      T.Text
  UniqueLogin                   mail password
  deriving Show
Session json
  key                           Int
  UniqueSession                 key
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
Memberlist json
  members                       [Member]
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

localTime :: IO (Integer, Int, Int)
localTime = do
    now <- getCurrentTime
    let(year, month, day) = toGregorian $ utctDay now
    return (year, month, day)

membersReady :: [Entity Member] -> (Integer, Int, Int) -> [Entity Member]
membersReady memberList (currYear, currMonth, currDay) = do
    L.filter (\x -> membersReadyFilter x (currDay, currMonth, toInteger currYear)) memberList

membersReadyList :: [Entity Member] -> (Integer, Int, Int) -> [Bool]
membersReadyList  memberList (currYear, currMonth, currDay) = do
    map (\x -> membersReadyFilter x (currDay, currMonth, toInteger currYear)) memberList

appointmentsInFuture :: [Entity Appointment] -> (Integer, Int, Int) -> [Entity Appointment]
appointmentsInFuture appointmentList (currYear, currMonth, currDay) = do
   L.filter (\x -> appointmentInFuture x (currDay, currMonth, toInteger currYear)) appointmentList


appointmentInFuture :: Entity Appointment -> (Int, Int, Integer)-> Bool
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

membersReadyFilter :: Entity Member -> (Int, Int, Integer)-> Bool
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

timeToString :: (Int, Int) -> String
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
