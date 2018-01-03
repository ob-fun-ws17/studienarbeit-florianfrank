-- | Module starts the program
module Main where

import Control.App

import System.Environment

-- | Starts the program reads the config file
main :: IO ()
main = do
    cfg <- parseConfig "Atemschutzplaner.cfg"
    init_view cfg
