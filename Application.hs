{-# LANGUAGE CPP, TemplateHaskell, MultiParamTypeClasses, OverloadedStrings #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}
module Application
  ( withTKYProf
  , withDevelAppPort
  ) where

import Data.ByteString (ByteString)
import Data.Dynamic (Dynamic, toDyn)
import Network.Wai (Application)
import Network.Wai.Middleware.Debug (debugHandle)
import Settings
import Foundation
import Yesod.Logger (makeLogger, flushLogger, Logger, logLazyText, logString)
-- Import all relevant handler modules here.
import Handler.Home
import Handler.Reports

-- This line actually creates our YesodSite instance. It is the second half
-- of the call to mkYesodData which occurs in TKYProf.hs. Please see
-- the comments there for more details.
mkYesodDispatch "TKYProf" resourcesTKYProf

-- Some default handlers that ship with the Yesod site template. You will
-- very rarely need to modify this.
getFaviconR :: Handler ()
getFaviconR = sendFile "image/png" "config/favicon.png"

getRobotsR :: Handler RepPlain
getRobotsR = return $ RepPlain $ toContent ("User-agent: *" :: ByteString)

-- This function allocates resources (such as a database connection pool),
-- performs initialization and creates a WAI application. This is also the
-- place to put your migrate statements to have automatic database
-- migrations handled by Yesod.
withTKYProf :: AppConfig -> Logger -> (Application -> IO a) -> IO a
withTKYProf config logger f = do
  rs <- atomically $ emptyReports
  s <- static Settings.staticDir
  let h = TKYProf { settings   = config
                  , getLogger  = logger
                  , getStatic  = s
                  , getReports = rs }
  toWaiApp h >>= f

withDevelAppPort :: Dynamic
withDevelAppPort = toDyn go
  where
    go :: ((Int, Application) -> IO ()) -> IO ()
    go f = do
      config <- Settings.loadConfig Settings.Development
      let port = appPort config
      logger <- makeLogger
      logString logger $ "Devel application launched, listening on port " ++ show port
      withTKYProf config logger $ \app -> f (port, debugHandle (logHandle logger) app)
      flushLogger logger
      where
        logHandle logger msg = logLazyText logger msg >> flushLogger logger
