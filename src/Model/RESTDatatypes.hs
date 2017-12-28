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

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
Login json -- The json keyword will make Persistent generate sensible ToJSON and FromJSON instances for us.
  mail                          T.Text
  password                      T.Text
  UniqueLogin                   mail password
  deriving Show
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
  UniqueMember                  name surName
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
|]
