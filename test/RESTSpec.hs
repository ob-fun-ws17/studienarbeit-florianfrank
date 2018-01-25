{-# LANGUAGE OverloadedStrings #-}
module RESTSpec (spec) where

-- import internal modules
import Model.RESTDatatypes


--import external modules
import Test.Hspec
import Test.QuickCheck


-- | Tests convertion functions of REST-Module
spec :: Spec -- ^ Testspec
spec =
    describe "toStringMethods" $ do
        it "dateToString tupel (1, 12, 2017) should be 12.01.2017" $
            dateToString (1, 12, 2017) `shouldBe` "12.01.2017"
        it "dateToString tupel (12, 31, 1978) should be 31.12.1978" $
            dateToString (12, 31, 1978) `shouldBe` "31.12.1978"
        it "dateToString tupel (12, 31, 1978) should be 31.12.1978" $
            dateToString (2, 29, 2016) `shouldBe` "29.02.2016"
        it "dateToString tupel (12, 31, 1978) should be 31.12.1978" $
            dateToString (1, 12, 1960) `shouldBe` "12.01.1960"
        it "timeToString tupel (22,33) should be 22:33" $
            timeToString (22, 33) `shouldBe` "22:33"
        it "timeToString tupel (3,0) should be 22:33" $
            timeToString (3, 0) `shouldBe` "03:00"
        it "timeToString tupel (2,33) should be 02:33" $
            timeToString (2, 33) `shouldBe` "02:33"
        it "timeToString tupel (0,0) should be 00:00" $
            timeToString (0, 0) `shouldBe` "00:00"
