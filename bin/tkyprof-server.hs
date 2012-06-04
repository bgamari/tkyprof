{-# LANGUAGE DeriveDataTypeable, CPP #-}
module Main where
import Yesod.Default.Config (fromArgs)
import Yesod.Default.Main   (defaultMain)
import Application          (makeApplication)

main :: IO ()
main = defaultMain (fromArgs (\_ _ -> return ())) makeApplication