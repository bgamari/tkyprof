{-# LANGUAGE TemplateHaskell #-}
module TKYProf.Controller.TimeAllocReport where
import Data.Aeson.TH (deriveJSON)
import Network.HTTP.Types (noContent204)
import Yesod.Content (RepJson)
import Yesod.Handler (sendResponseStatus)
import Yesod.Json (jsonToRepJson)
import Yesod.Persist (runDB)

import TKYProf.Controller.Internal
import TKYProf.Model
import qualified TKYProf.Model.TimeAllocReport as Report

data PostReport = PostReport
  { postReportCommandLine :: Text
  , postReportRawData     :: ByteString
  }

$(deriveJSON (removePrefix "postReport") ''PostReport)

postTimeAllocReportsR :: ProjectId -> Handler RepJson
postTimeAllocReportsR projectId = do
  PostReport commandLine rawData <- parseJsonBody
  report <- runDB $ Report.create projectId commandLine rawData
  jsonToRepJson report

getTimeAllocReportIdR :: ProjectId -> TimeAllocReportId -> Handler RepJson
getTimeAllocReportIdR _projectId reportId =
  runDB (Report.get reportId) >>= jsonToRepJson

deleteTimeAllocReportIdR :: ProjectId -> TimeAllocReportId -> Handler RepJson
deleteTimeAllocReportIdR _projectId reportId = do
  runDB $ Report.delete reportId
  sendResponseStatus noContent204 ()
