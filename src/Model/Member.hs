module Model.Member where

import Data.List
import Data.String


type Day = Int
type Month = Int
type Year = Int
type Date = (Day, Month, Year)

type FirstName = String
type SurName = String
type Birthday = Date
type NextExamationAppointment = Date
type InstructionCheck = Bool
type ExerciseCheck = Bool

type Member = ( FirstName
              , SurName
              , Birthday
              , NextExamationAppointment
              , InstructionCheck
              , ExerciseCheck
              )


testMembers :: [Member]
testMembers =
    [
    ("Max",   "Mustermann", (1, 2, 1978),  (12,9,2018),  False, True),
    ("Peter", "Lustig",     (1, 12, 1989), (6,10,2019), True, True)
    ]

getFirstName :: Member -> String
getFirstName (x, _, _, _, _, _) =
    x

getSurName :: Member -> String
getSurName (_, x, _, _, _, _) =
    x

getBrithDayStr :: Member -> String
getBrithDayStr (_, _, x, _, _, _) =
    dateToString x

getNextExamationAppointmentStr :: Member -> String
getNextExamationAppointmentStr (_, _, _, x, _, _) =
    dateToString x

getInstructionCheckStr :: Member -> String
getInstructionCheckStr (_, _, _, _, x, _) =
    if x == True then "Ja" else "Nein"

getExerciseCheckStr :: Member -> String
getExerciseCheckStr (_, _, _, _, _, x) =
    if x == True then "Ja" else "Nein"



dateToString :: Date -> String
dateToString (d, m, y) = str where
                    day  =
                        if (d < 10) then
                            "0" ++ show d
                        else
                            " " ++ show d
                    month =
                        if (m < 10) then
                            "0" ++ show d
                        else
                            " " ++ show d
                    str = day ++ "." ++ month ++ "." ++ show y
