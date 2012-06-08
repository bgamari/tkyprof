module TKYProf.Controller.TimeAllocReport where
import Yesod.Content
import Yesod.Core

import TKYProf.Model

postTimeAllocReportsR :: ProjectId -> GHandler master sub RepJson
postTimeAllocReportsR = undefined

getTimeAllocReportIdR :: ProjectId -> TimeAllocReportId -> GHandler master sub RepJson
getTimeAllocReportIdR = undefined

deleteTimeAllocReportIdR :: ProjectId -> TimeAllocReportId -> GHandler master sub RepJson
deleteTimeAllocReportIdR = undefined
