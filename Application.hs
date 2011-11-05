{-# LANGUAGE CPP, TemplateHaskell, MultiParamTypeClasses, OverloadedStrings #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}
module Application
  ( withTKYProf
  , withDevelAppPort
  ) where

import Data.Dynamic (Dynamic, toDyn)
import Foundation
import Network.Wai (Application)
import Yesod.Default.Config (DefaultEnv)
import Yesod.Default.Handlers (getRobotsR)
import Yesod.Default.Main (defaultDevelApp, defaultRunner)
import Yesod.Logger (Logger)
import qualified Settings as S

-- Import all relevant handler modules here.
import Handler.Home
import Handler.Reports

mkYesodDispatch "TKYProf" resourcesTKYProf

-- A Favicon handler for a PNG image
getFaviconR :: Handler ()
getFaviconR = sendFile "image/png" "config/favicon.png"

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
