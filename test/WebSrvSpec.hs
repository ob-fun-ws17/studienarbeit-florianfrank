{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE QuasiQuotes                #-}
-- | Module Tests Web and RESTServices such as the Database
module WebSrvSpec (spec) where

-- import internal modules
import Control.App (app)
import Model.Config as C

-- import external modules
import                      Test.Hspec
import                      Test.Hspec.Wai
import                      Test.Hspec.Wai.JSON as J
import                      Test.Hspec.Wai.Matcher
import                      Web.Spock.Config
import                      Control.Monad.Logger
import                      Database.Persist.Sqlite hiding (get,post)
import                      Web.Spock hiding (get,post)
import qualified            Data.ByteString.Lazy.Char8 as L


getConfig cfg =
    do pool <- runStdoutLoggingT $ createSqlitePool (db_name cfg) 5
       spockCfg <- defaultSpockCfg Nothing (PCPool pool) (State cfg)
       spockAsApp $ spock spockCfg app


-- | Tests REST and Database Functions
spec :: Spec -- ^ Testspec
spec =
   with (getConfig (Config "test.db" 8080)) $
       do describe "GET /createTable" $
              do it "Check if the creation of sqlite tables is possible!" $
                     get "/createTable" `shouldRespondWith` 200
          describe "GET /appointmentmanagement" $
                do it "Test if AppointmentManagement is not available if user is not logged in!" $ do
                       --s <- liftIO $ readFile "test/testfiles/appointmentmanagementTest.txt"
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
          describe "POST register" $
                do it "Test if registration works! (Set mail:\"Test@test.de\", password: \"Test\", (Hash: -9045014743692993354))" $ do
                        post "register" [J.json|{mail: "Test@test.de" ,password: "Test"}|] `shouldRespondWith`  "{\"result\":\"success\",\"id\":1}" {matchStatus = 200}
          describe "POST login" $
                do it "Test if login is impossible when using false password! (Get mail:\"Test@test.de\", password: \"Test2\")" $ do
                        post "login" [J.json|{mail: "Test@test.de" ,password: "Test2"}|] `shouldRespondWith`  "{\"error\":{\"code\":2,\"message\":\"Could not find a person with matching id\"},\"result\":\"failure\"}" {matchStatus = 200}
          describe "POST login" $
                do it "Test if login is possible! (Get mail:\"Test@test.de\", password: \"Test\")" $ do
                        post "login" [J.json|{mail: "Test@test.de" ,password: "Test"}|] `shouldRespondWith` "{\"password\":\"-9045014743692993354\",\"id\":1,\"mail\":\"Test@test.de\"}" {matchStatus = 200}
          describe "POST addMember" $
                do it "Test addMember Works with {name: \"Mustermann\" ,surName: \"Max\", birthDay: 31, \
                            \ birthMonth: 8, birthYear: 1993, examationDay: 1, examationMonth: 2, examationYear: 2019, \
                             \ instructionCheck: 0, exerciseCheck: 0}" $ do
                        post "addMember" [J.json|{name: "Mustermann" ,surName: "Max", birthDay: 31,
                            birthMonth: 8, birthYear: 1993, examationDay: 1, examationMonth: 2, examationYear: 2019,
                            instructionCheck: 0, exerciseCheck: 0}|]
                                `shouldRespondWith` "{\"result\":\"success\",\"id\":1}" {matchStatus = 200}
          describe "POST addMember" $
                do it "Test if addMember Works with {name: \"Mustermann\" ,surName: \"Petra\", birthDay: 21, \
                            \ birthMonth: 12, birthYear: 2000, examationDay: 2, examationMonth: 2, examationYear: 2017, \
                            \ instructionCheck: 0, exerciseCheck: 0}" $ do
                      post "addMember" [J.json|{name: "Mustermann" ,surName: "Petra", birthDay: 21,
                          birthMonth: 12, birthYear: 2000, examationDay: 2, examationMonth: 2, examationYear: 2017,
                          instructionCheck: 0, exerciseCheck: 0}|]
                              `shouldRespondWith` "{\"result\":\"success\",\"id\":2}" {matchStatus = 200}
          describe "POST addMember" $
                do it "Test if addMember Works with {name: \"Wagner\" ,surName: \"Katja\", birthDay: 27, \
                            \ birthMonth: 1, birthYear: 1993, examationDay: 4, examationMonth: 1, examationYear: 2019, \
                            \ instructionCheck: 1, exerciseCheck: 1}" $ do
                      post "addMember" [J.json|{name: "Wagner" ,surName: "Katja", birthDay: 27,
                          birthMonth: 1, birthYear: 1993, examationDay: 4, examationMonth: 1, examationYear: 2019,
                          instructionCheck: 1, exerciseCheck: 1}|]
                              `shouldRespondWith` "{\"result\":\"success\",\"id\":3}" {matchStatus = 200}
          describe "POST addMember" $
                do it "Test if addMember Works with {name: \"Frank\" ,surName: \"Florian\", birthDay: 31, \
                            \ birthMonth: 8, birthYear: 1993, examationDay: 4, examationMonth: 1, examationYear: 2019, \
                            \ instructionCheck: 1, exerciseCheck: 1}" $ do
                      post "addMember" [J.json|{name: "Fank" ,surName: "Florian", birthDay: 31,
                          birthMonth: 8, birthYear: 1993, examationDay: 22, examationMonth: 11, examationYear: 2020,
                          instructionCheck: 1, exerciseCheck: 1}|]
                              `shouldRespondWith` "{\"result\":\"success\",\"id\":4}" {matchStatus = 200}
          describe "POST addAppointment" $
                do it "Test if addAppointment Works with {title: \"Test\" ,type: \"Übung\", day: 27, \
                            \ month: 9, year: 2017, hour: 19, minute: 0, members: []}" $ do
                      post "addAppointment" [J.json|{title: "Test", type: "Übung", day: 27,
                          month: 9, year: 2017, hour: 19, minute: 0, members: []}|]
                              `shouldRespondWith` "{\"result\":\"success\",\"id\":1}" {matchStatus = 200}
          describe "POST addAppointment" $
                do it "Test if addAppointment Works with {title: \"Zimmerbrand\", type: \"Einsatz\", day: 12, \
                        \ month: 3, year: 2017, hour: 19, minute: 0, members: [\"Florian Frank\", \"Katja Wagner\"]}" $ do
                      post "addAppointment" [J.json|{title: "Zimmerbrand", type: "Einsatz", day: 12,
                          month: 3, year: 2017, hour: 8, minute: 33, members: ["Florian Frank", "Katja Wagner"]}|]
                              `shouldRespondWith` "{\"result\":\"success\",\"id\":2}" {matchStatus = 200}
          describe "POST addAppointment" $
                do it "Test if addAppointment Works with {title: \"Schulung WBK\", type: \"Unterweisung\", day: 1, \
                        \ month: 1, year: 2015, hour: 19, minute: 0, members: [\"Florian Frank\", \"Katja Wagner\"]}" $ do
                      post "addAppointment" [J.json|{title: "Schulung WBK", type: "Unterweisung", day: 2,
                          month: 1, year: 2015, hour: 19, minute: 0, members: ["Florian Frank", "Katja Wagner"]}|]
                              `shouldRespondWith` "{\"result\":\"success\",\"id\":3}" {matchStatus = 200}
          describe "POST addAppointment" $
                do it "Test if addAppointment fails with an existing appointment {title: \"Zimmerbrand\", type: \"Einsatz\", day: 12, \
                    \ month: 3, year: 2017, hour: 19, minute: 0, members: [\"Florian Frank\", \"Katja Wagner\"]}" $ do
                        post "addAppointment" [J.json|{title: "Zimmerbrand", type: "Einsatz", day: 12,
                        month: 3, year: 2017, hour: 8, minute: 33, members: ["Florian Frank", "Katja Wagner"]}|]
                          `shouldRespondWith` 500
          describe "POST addAppointment" $
                do it "Test if addAppointment fails with false JSON format {title: \"Zimmerbrand\" \
                    \ day: 12, month: 3, year: 2017, hour: 19, minute: 0, members: [\"Florian Frank\", \"Katja Wagner\"]}" $ do
                        post "addAppointment" [J.json|{title: "Zimmerbrand", day: 12, month: 3, year: 2017, hour: 8, minute: 33,
                            members: ["Florian Frank", "Katja Wagner"]}|]
                                `shouldRespondWith` "{\"error\":{\"code\":1,\"message\":\"Failed to parse request body as Member Data\"},\"result\":\"failure\"}"
          describe "POST deleteMember" $
                do it "Test if deleteMember Works with {members: [{name: \"Frank\" ,surName: \"Florian\", birthDay: 31, \
                            \ birthMonth: 8, birthYear: 1993, examationDay: 4, examationMonth: 1, examationYear: 2019, \
                            \ instructionCheck: 1, exerciseCheck: 1}]}" $ do
                      post "deleteMember" [J.json|{members: [{name: "Fank" ,surName: "Florian", birthDay: 31,
                          birthMonth: 8, birthYear: 1993, examationDay: 22, examationMonth: 11, examationYear: 2020,
                          instructionCheck: 1, exerciseCheck: 1}]}|]
                              `shouldRespondWith` "{\"result\":\"success\",\"id\":[]}" {matchStatus = 200}
          describe "POST deleteMember" $
                do it "Test if deleteMember Works with {name: \"Wagner\" ,surName: \"Katja\", birthDay: 27, \
                            \ birthMonth: 1, birthYear: 1993, examationDay: 4, examationMonth: 1, examationYear: 2019, \
                            \ instructionCheck: 1, exerciseCheck: 1}" $ do
                      post "deleteMember" [J.json|{members: [{name: "Wagner" ,surName: "Katja", birthDay: 27,
                          birthMonth: 1, birthYear: 1993, examationDay: 4, examationMonth: 1, examationYear: 2019,
                          instructionCheck: 1, exerciseCheck: 1}]}|]
                              `shouldRespondWith` "{\"result\":\"success\",\"id\":[]}" {matchStatus = 200}
          describe "POST deleteAppointment" $
                do it "Test if deleteAppointment works with {appointments: [{title: \"Test\" ,type: \"Übung\", day: 27, \
                            \ month: 9, year: 2017, hour: 19, minute: 0, members: []}]}" $ do
                      post "deleteAppointment" [J.json|{appointments: [{title: "Test", type: "Übung", day: 27,
                          month: 9, year: 2017, hour: 19, minute: 0, members: []}]}|]
                              `shouldRespondWith` "{\"result\":\"success\",\"id\":[]}" {matchStatus = 200}
          describe "POST deleteAppointment" $
                do it "Test if deleteAppointment works with {appointments: [{title: \"Schulung WBK\", type: \"Unterweisung\", day: 1, \
                        \ month: 1, year: 2015, hour: 19, minute: 0, members: [\"Florian Frank\", \"Katja Wagner\"]}]}" $ do
                      post "deleteAppointment" [J.json|{appointments: [{title: "Schulung WBK", type: "Unterweisung", day: 2,
                          month: 1, year: 2015, hour: 19, minute: 0, members: ["Florian Frank", "Katja Wagner"]}]}|]
                              `shouldRespondWith` "{\"result\":\"success\",\"id\":[]}" {matchStatus = 200}
          describe "POST logoutUser" $
                do it "Test if logout Works" $ do
                      post "logoutUser" [J.json|{key: 0}|]
                              `shouldRespondWith` "{\"result\":\"success\",\"id\":[]}" {matchStatus = 200}
