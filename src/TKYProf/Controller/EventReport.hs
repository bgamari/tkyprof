module TKYProf.Controller.EventReport where
import Yesod.Content

import TKYProf.Controller.Internal
import TKYProf.Model

postEventReportsR :: ProjectId -> Handler RepJson
postEventReportsR = undefined

getEventReportIdR :: ProjectId -> EventReportId -> Handler RepJson
getEventReportIdR = undefined

deleteEventReportIdR :: ProjectId -> EventReportId -> Handler RepJson
deleteEventReportIdR = undefined
