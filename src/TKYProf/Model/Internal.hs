{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
module TKYProf.Model.Internal
  ( ByteString
  , UTCTime
  , Text
  , module TKYProf.Model.Internal
  , module Database.Persist
  ) where

import Data.ByteString (ByteString)
import Data.Time (UTCTime)
import Data.Text (Text)

import Data.Aeson (ToJSON(..), (.=))
import qualified Data.Aeson as A
import Database.Persist
import Database.Persist.TH
import Database.Persist.Quasi (lowerCaseSettings)

share [mkPersist sqlSettings, mkMigrate "migrateAll"]
  $(persistFileWith lowerCaseSettings "config/models")

instance ToJSON (Entity Project) where
  toJSON (Entity key (Project {..})) =
    A.object [ "id"        .= key
             , "name"      .= projectName
             , "createdAt" .= projectCreatedAt
             ]

instance ToJSON (Entity TimeAllocReport) where
  toJSON (Entity key (TimeAllocReport {..})) =
    A.object [ "id"          .= key
             , "projectId"   .= timeAllocReportProjectId
             , "commandLine" .= timeAllocReportCommandLine
             , "rawData"     .= timeAllocReportRawData
             , "createdAt"   .= timeAllocReportCreatedAt
             ]

instance ToJSON (Entity HeapReport) where
  toJSON (Entity key (HeapReport {..})) =
    A.object [ "id"          .= key
             , "projectId"   .= heapReportProjectId
             , "commandLine" .= heapReportCommandLine
             , "rawData"     .= heapReportRawData
             , "createdAt"   .= heapReportCreatedAt
             ]

instance ToJSON (Entity EventReport) where
  toJSON (Entity key (EventReport {..})) =
    A.object [ "id"          .= key
             , "projectId"   .= eventReportProjectId
             , "commandLine" .= eventReportCommandLine
             , "rawData"     .= eventReportRawData
             , "createdAt"   .= eventReportCreatedAt
             ]
