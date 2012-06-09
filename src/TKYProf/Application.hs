{-# LANGUAGE CPP #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}
module TKYProf.Application
  ( makeApplication
  ) where

import Database.Persist.GenericSql (runSqlPool, runMigration)
import Database.Persist.Sqlite (withSqlitePool)
import Network.Wai (Application)
import Yesod.Core (toWaiApp)
import Yesod.Default.Config (AppConfig, DefaultEnv)
import Yesod.Logger (Logger)
import Yesod.Static (static)

import TKYProf.Controller
import TKYProf.Model (migrateAll)
import qualified Settings as S

makeApplication :: AppConfig DefaultEnv () -> Logger -> IO Application
makeApplication config logger = do
  st <- static S.staticDir
  withSqlitePool ":memory:" 1 $ \pool -> do
    runSqlPool (runMigration migrateAll) pool
    toWaiApp TKYProf { tkyConfig   = config
                     , tkyLogger   = logger
                     , tkyStatic   = st
                     , tkyConnPool = pool
                     }
