module TKYProf.Controller.EventReport where
import Yesod.Content
import Yesod.Core

import TKYProf.Model

postEventReportsR :: ProjectId -> GHandler master sub RepJson
postEventReportsR = undefined

getEventReportIdR :: ProjectId -> EventReportId -> GHandler master sub RepJson
getEventReportIdR = undefined

deleteEventReportIdR :: ProjectId -> EventReportId -> GHandler master sub RepJson
deleteEventReportIdR = undefined
