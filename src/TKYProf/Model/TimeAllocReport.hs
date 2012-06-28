module TKYProf.Model.TimeAllocReport
  ( module Database.Persist
  , create
  ) where
import Control.Monad.Trans (MonadIO(..))
import Data.Time.Clock (getCurrentTime)

import Database.Persist

import TKYProf.Model.Internal

create
  :: (MonadIO (b m), PersistStore b m)
  => Key b (ProjectGeneric b)
  -> Text
  -> ByteString
  -> b m (Entity (TimeAllocReportGeneric b))
create projectId commandLine rawData = do
  createdAt <- liftIO getCurrentTime
  let report = TimeAllocReport
        { timeAllocReportProjectId   = projectId
        , timeAllocReportCommandLine = commandLine
        , timeAllocReportRawData     = rawData
        , timeAllocReportCreatedAt   = createdAt
        }
  rid <- insert report
  return $ Entity rid report
