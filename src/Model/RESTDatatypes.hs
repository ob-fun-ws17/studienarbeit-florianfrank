{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Model.RESTDatatypes where

import           Data.Aeson       hiding (json)
import           GHC.Generics
import qualified Data.Text as T

instance ToJSON Login

instance FromJSON Login

data Login = Login
  { mail :: T.Text
  , password  :: T.Text
  } deriving (Generic, Show)
