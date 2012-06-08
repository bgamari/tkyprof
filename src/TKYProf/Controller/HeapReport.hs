module TKYProf.Controller.HeapReport where
import Yesod.Content

import TKYProf.Controller.Internal
import TKYProf.Model

postHeapReportsR :: ProjectId -> Handler RepJson
postHeapReportsR = undefined

getHeapReportIdR :: ProjectId -> HeapReportId -> Handler RepJson
getHeapReportIdR = undefined

deleteHeapReportIdR :: ProjectId -> HeapReportId -> Handler RepJson
deleteHeapReportIdR = undefined
