{-# LANGUAGE CPP, TemplateHaskell, MultiParamTypeClasses, OverloadedStrings #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}
module Application
  ( makeApplication
  ) where

import Foundation
import Network.Wai (Application)
import Yesod.Default.Config (AppConfig, DefaultEnv)
import Yesod.Default.Handlers (getRobotsR)
import Yesod.Logger (Logger)
import qualified Settings as S

-- Import all relevant handler modules here.
import Handler.Home
import Handler.Reports

mkYesodDispatch "TKYProf" resourcesTKYProf

-- A Favicon handler for a PNG image
getFaviconR :: Handler ()
getFaviconR = sendFile "image/png" "config/favicon.png"

makeApplication :: AppConfig DefaultEnv () -> Logger -> IO Application
makeApplication config logger = do
  rs <- atomically $ emptyReports
  s <- static S.staticDir
  toWaiApp TKYProf { settings   = config
                   , getLogger  = logger
                   , getStatic  = s
                   , getReports = rs }
