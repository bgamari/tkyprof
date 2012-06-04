{-# LANGUAGE QuasiQuotes, TemplateHaskell, TypeFamilies, OverloadedStrings #-}
module Foundation
  ( TKYProf (..)
  , Route (..)
  , resourcesTKYProf
  , Handler
  , Widget
  , module Yesod.Core
  , module Settings
  , module Settings.StaticFiles
  , module Model
  , module Control.Monad.STM
  , liftIO
  ) where

import Control.Monad.IO.Class (liftIO)
import Control.Monad.STM (STM, atomically)
import Data.Monoid ((<>))
import Model
import Settings (widgetFile)
import Settings.StaticFiles
import Text.Hamlet (hamletFile)
import Yesod.Core
import Yesod.Default.Config (AppConfig(..), DefaultEnv)
import Yesod.Default.Util (addStaticContentExternal)
import Yesod.Logger (Logger, logLazyText)
import Yesod.Static
import qualified Data.Text as T
import qualified Settings
import Text.Jasmine (minifym)

data TKYProf = TKYProf
  { settings   :: AppConfig DefaultEnv ()
  , getLogger  :: Logger
  , getStatic  :: Static
  , getReports :: Reports
  }

mkYesodData "TKYProf" $(parseRoutesFile "config/routes")

instance Yesod TKYProf where
  approot = ApprootMaster $ appRoot . settings

  defaultLayout widget = do
    mmsg <- getMessage
    (title, bcs) <- breadcrumbs
    pc <- widgetToPageContent $ do
      -- $(widgetFile "normalize")
      $(widgetFile "header")
      $(widgetFile "default-layout")
    hamletToRepHtml $(hamletFile "templates/default-layout-wrapper.hamlet")

  urlRenderOverride y (StaticR s) =
    Just $ uncurry (joinPath y (Settings.staticRoot $ settings y)) $ renderRoute s
  urlRenderOverride _ _ = Nothing

  messageLogger y loc level msg =
    formatLogMessage loc level msg >>= logLazyText (getLogger y)

  addStaticContent =
    addStaticContentExternal minifym base64md5 Settings.staticDir (StaticR . flip StaticRoute [])

  jsLoader _ = BottomOfBody


instance YesodBreadcrumbs TKYProf where
  breadcrumb route = return $ case route of
    HomeR                 -> ("Home", Nothing)
    ReportsR              -> ("Reports", Just HomeR)
    ReportsIdTimeR rid _  -> ("Report #" <> T.pack (show rid), Just ReportsR)
    ReportsIdAllocR rid _ -> ("Report #" <> T.pack (show rid), Just ReportsR)
    _                     -> ("Not found", Just HomeR)
