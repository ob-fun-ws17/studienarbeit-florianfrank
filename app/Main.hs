module Main where

import Control.App

import System.Environment

main :: IO ()
main = do
    cfg <- parseConfig "Atemschutzplaner.cfg"
    init_view cfg
