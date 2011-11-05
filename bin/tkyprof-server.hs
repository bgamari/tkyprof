{-# LANGUAGE DeriveDataTypeable, CPP #-}
module Main where
import Yesod.Default.Config (fromArgs)
import Yesod.Default.Main   (defaultMain)
import Application          (withTKYProf)

main :: IO ()
main = defaultMain fromArgs withTKYProf