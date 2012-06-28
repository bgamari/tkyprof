module Main where
import Control.Concurrent (forkIO, threadDelay)
import Control.Monad (void)
import System.Directory (doesFileExist)
import System.Exit (exitSuccess)

import Network.Wai.Handler.Warp (run)
import Yesod.Default.Config (loadDevelopmentConfig, appPort)
import Yesod.Logger (defaultDevelopmentLogger)

import TKYProf.Application (makeApplication)

main :: IO ()
main = do
  putStrLn "Starting devel app"
  conf <- loadDevelopmentConfig
  logger <- defaultDevelopmentLogger
  app <- makeApplication conf logger
  void . forkIO $ run (appPort conf) app
  loop

loop :: IO ()
loop = do
  threadDelay 100000
  exist <- doesFileExist "dist/devel-terminate"
  if exist then exitSuccess else loop
