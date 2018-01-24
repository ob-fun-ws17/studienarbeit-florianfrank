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
module WebSrvSpec (spec) where

import Data.String
import Control.App
import Model.Config as C
import Test.Hspec
import Test.Hspec.Wai
import Test.Hspec.Wai.JSON as J
import Test.Hspec.Wai.Matcher
import Web.Spock.Config
import Control.Monad.Logger
import Database.Persist.Sqlite hiding (get,post)
import Web.Spock hiding (get,post)--(spockAsApp, spock)
import qualified Data.ByteString.Lazy.Char8 as L



getConfig cfg =
    do pool <- runStdoutLoggingT $ createSqlitePool (db_name cfg) 5
       spockCfg <- defaultSpockCfg Nothing (PCPool pool) (State cfg)
       spockAsApp $ spock spockCfg app



spec :: Spec
spec =
   with (getConfig (Config "test.db" 8080)) $
       do describe "GET /createTable" $
              do it "Check if the creation of sqlite tables is possible!" $
                     get "/createTable" `shouldRespondWith` 200
          describe "GET /appointmentmanagement" $
                do it "Test if AppointmentManagement is not available if user is not logged in!" $ do
                       s <- liftIO $ readFile "test/testfiles/appointmentmanagementTest.txt"
                       get "/appointmentmanagement" `shouldRespondWith` 200 -- "" { matchStatus = 200 , matchBody = (fromString (s) :: MatchBody)}
          describe "GET /membermanagement" $
                 do it "Test if AppointmentManagement is not available if user is not logged in!" $ do
                        --s <- liftIO $ readFile "test/testfiles/membermanagementTest.txt"
                        get "/membermanagement" `shouldRespondWith` 200 -- "" { matchStatus = 200 , matchBody = (fromString (s) :: MatchBody)}
          describe "GET /home" $
                do it "Test if Home is available!" $ do
                        get "/home" `shouldRespondWith`  200
          describe "GET /logout" $
                do it "Test if Logout is available!" $ do
                        get "/logout" `shouldRespondWith`  200
          describe "GET /impressum" $
                do it "Test if Impressum is available!" $ do
                        get "/impressum" `shouldRespondWith`  200
          describe "GET /register" $
                do it "Test if register is available!" $ do
                        get "/register" `shouldRespondWith`  200
          describe "POST /register" $
                do it "Test if registration works! (Set mail:\"Test@test.de\", password: \"Test\")" $ do
                        post "register" [J.json|{mail: "Test@test.de" ,password: "Test"}|] `shouldRespondWith`  "{\"result\":\"success\",\"id\":1}" {matchStatus = 200}
          describe "POST /login" $
                do it "Test if login is impossible when using false password! (Get mail:\"Test@test.de\", password: \"Test2\")" $ do
                        post "login" [J.json|{mail: "Test@test.de" ,password: "Test2"}|] `shouldRespondWith`  "{\"error\":{\"code\":2,\"message\":\"Could not find a person with matching id\"},\"result\":\"failure\"}" {matchStatus = 200}
          describe "POST /login" $
                do it "Test if login is possible! (Get mail:\"Test@test.de\", password: \"Test\")" $ do
                        post "login" [J.json|{mail: "Test@test.de" ,password: "Test"}|] `shouldRespondWith` "{\"password\":\"Test\",\"id\":1,\"mail\":\"Test@test.de\"}" {matchStatus = 200}
