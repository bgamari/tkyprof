{-# LANGUAGE DeriveDataTypeable, CPP #-}
module Main where
import Control.Applicative ((<$>))

import Network.Wai.Handler.Warp (runSettings, defaultSettings, settingsPort)
import Network.Wai.Middleware.RequestLogger (logStdoutDev)
import Yesod.Default.Config (AppConfig, appPort, fromArgs)
import Yesod.Logger (defaultProductionLogger)

import TKYProf.Application (makeApplication)

main :: IO ()
main = do
  config <- fromArgs (\_ _ -> return ())
  logger <- defaultProductionLogger
  app <- logStdoutDev <$> makeApplication config logger
  runSettings defaultSettings
    { settingsPort = appPort config
    } app
