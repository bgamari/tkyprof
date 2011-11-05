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
import qualified Settings as S
import Foundation
import Yesod.Logger (makeLogger, flushLogger, Logger, logLazyText, logString)
import Yesod.Default.Handlers (getFaviconR, getRobotsR)
import Yesod.Default.Config (DefaultEnv)
import Yesod.Default.Main (defaultDevelApp, defaultRunner)

-- Import all relevant handler modules here.
import Handler.Home
import Handler.Reports

mkYesodDispatch "TKYProf" resourcesTKYProf

withTKYProf :: AppConfig DefaultEnv -> Logger -> (Application -> IO ()) -> IO ()
withTKYProf config logger f = do
  rs <- atomically $ emptyReports
  s <- static S.staticDir
  let h = TKYProf { settings   = config
                  , getLogger  = logger
                  , getStatic  = s
                  , getReports = rs }
  defaultRunner f h

withDevelAppPort :: Dynamic
withDevelAppPort = toDyn $ defaultDevelApp withTKYProf
