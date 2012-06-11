module TKYProf.Model.Project
  ( module Database.Persist
  , create
  ) where
import Control.Monad.Trans (MonadIO(..))
import Data.Time.Clock (getCurrentTime)

import Database.Persist

import TKYProf.Model.Internal

create :: (MonadIO (b m), PersistStore b m)
       => Text
       -> b m (Entity (ProjectGeneric b))
create name = do
  createdAt <- liftIO getCurrentTime
  let project = Project
        { projectName      = name
        , projectCreatedAt = createdAt
        , projectUpdatedAt = createdAt
        }
  pid <- insert project
  return $ Entity pid project

touch :: (MonadIO (b m), PersistQuery b m) => Key b Project -> b m ()
touch pid = do
    updatedAt <- liftIO getCurrentTime
    update pid [ ProjectUpdatedAt =. updatedAt ]
