
module RESTSpec (spec) where

import Model.RESTDatatypes (dateToString, timeToString)

import Test.Hspec
import Test.QuickCheck

import Web.Spock.Config
import Control.Monad.Logger
import Database.Persist.Sqlite
import Web.Spock (spockAsApp, spock)


spec:: Spec
spec =
    describe "toStringMethods" $ do
        it "dateToString tupel (1, 12, 2017) should be 12.01.2017" $
            dateToString (1, 12, 2017) `shouldBe` "12.01.2017"
        it "dateToString tupel (12, 31, 1978) should be 31.12.1978" $
            dateToString (12, 31, 1978) `shouldBe` "31.12.1978"
        it "timeToString tupel (22,33) should be 22:33" $
            timeToString (22, 33) `shouldBe` "22:33"
        it "timeToString tupel (3,0) should be 22:33" $
            timeToString (3, 0) `shouldBe` "03:00"
