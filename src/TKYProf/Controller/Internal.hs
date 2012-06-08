{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
module TKYProf.Controller.Internal where
import Database.Persist.GenericSql (ConnectionPool, SqlPersist, runSqlPool)
import Text.Hamlet (hamletFile)
import Text.Jasmine (minifym)
import Yesod.Core
import Yesod.Default.Config (AppConfig(..), DefaultEnv)
import Yesod.Default.Util (addStaticContentExternal)
import Yesod.Logger (Logger, logLazyText)
import Yesod.Persist
import Yesod.Static (Static, Route(StaticRoute), base64md5)

import TKYProf.Model

import Settings (widgetFile)
import qualified Settings
import Settings.StaticFiles

data TKYProf = TKYProf
  { tkyConfig   :: AppConfig DefaultEnv ()
  , tkyLogger   :: Logger
  , tkyStatic   :: Static
  , tkyConnPool :: ConnectionPool
  }

mkYesodData "TKYProf" $(parseRoutesFile "config/routes2")

instance Yesod TKYProf where
  approot = ApprootMaster $ appRoot . tkyConfig

  defaultLayout widget = do
    mmsg <- getMessage
    (title, bcs) <- breadcrumbs
    pc <- widgetToPageContent $ do
      -- $(widgetFile "normalize")
      $(widgetFile "header")
      $(widgetFile "default-layout")
    hamletToRepHtml $(hamletFile "templates/default-layout-wrapper.hamlet")

  urlRenderOverride y (StaticR s) =
    Just $ uncurry (joinPath y (Settings.staticRoot $ tkyConfig y)) $ renderRoute s
  urlRenderOverride _ _ = Nothing

  messageLogger y loc level msg =
    formatLogMessage loc level msg >>= logLazyText (tkyLogger y)

  addStaticContent =
    addStaticContentExternal minifym base64md5 Settings.staticDir (StaticR . flip StaticRoute [])

  jsLoader _ = BottomOfBody

instance YesodBreadcrumbs TKYProf where
  breadcrumb route = return $ case route of
    _                     -> ("Not found", Just HomeR)

instance YesodPersist TKYProf where
  type YesodPersistBackend TKYProf = SqlPersist
  runDB act = do
    tkyprof <- getYesod
    runSqlPool act $ tkyConnPool tkyprof

