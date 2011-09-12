{-# LANGUAGE DeriveDataTypeable, CPP #-}
module Main where
import Application (withTKYProf)
import Data.Char (toUpper, toLower)
import Data.List (intercalate)
import Data.Version (showVersion)
import Network.Wai.Handler.Warp (Port, run)
import Paths_tkyprof (getDataDir, version)
import Settings (AppConfig(..))
import System.Console.CmdArgs hiding (args)
import System.Directory (setCurrentDirectory)
import System.IO (hPutStrLn, stderr)
import Yesod.Logger (makeLogger)
import qualified Settings as Settings

#ifndef PRODUCTION
import Network.Wai.Middleware.Debug (debugHandle)
import Yesod.Logger (logLazyText, flushLogger)
#endif

main :: IO ()
main = do
  getDataDir >>= setCurrentDirectory
  logger <- makeLogger
  args <- cmdArgs tkyConfig
  env <- getAppEnv args
  config <- Settings.loadConfig env
  let c = if port args /= 0
            then config { appPort = port args }
            else config
  hPutStrLn stderr $
    "TKYProf " ++ showVersion version ++
    " launched, listening on http://localhost:" ++ show (appPort c) ++ "/"
#if PRODUCTION
  withTKYProf c logger $ run (appPort c)
#else
  withTKYProf c logger $ run (appPort c) . debugHandle (logHandle logger)
  flushLogger logger
  where
    logHandle logger msg = logLazyText logger msg >> flushLogger logger
#endif

data TKYConfig = TKYConfig
  { environment :: String
  , port        :: Port
  } deriving (Show, Data, Typeable)

tkyConfig :: TKYConfig
tkyConfig = TKYConfig
  { environment = def
      &= help ("application environment, one of: " ++ intercalate ", " environments)
      &= typ "ENVIRONMENT"
  , port = 3000
      &= typ "PORT"
  } &= summary ("TKYProf " ++ showVersion version)

environments :: [String]
environments = map ((map toLower) . show) ([minBound..maxBound] :: [Settings.AppEnvironment])

-- | retrieve the -e environment option
getAppEnv :: TKYConfig ->  IO Settings.AppEnvironment
getAppEnv cfg = do
    let e = if (environment cfg) /= "" then (environment cfg)
            else
#if PRODUCTION
                  "production"
#else
                  "development"
#endif
    return $ read $ capitalize e
  where
    capitalize [] = []
    capitalize (x:xs) = toUpper x : map toLower xs
