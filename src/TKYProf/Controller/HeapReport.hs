module TKYProf.Controller.HeapReport where
import Yesod.Content

import TKYProf.Controller.Internal
import TKYProf.Model

getHeapReportsR :: ProjectId -> Handler RepJson
getHeapReportsR = undefined

postHeapReportsR :: ProjectId -> Handler RepJson
postHeapReportsR = undefined

getHeapReportIdR :: ProjectId -> HeapReportId -> Handler RepJson
getHeapReportIdR = undefined

deleteHeapReportIdR :: ProjectId -> HeapReportId -> Handler RepJson
deleteHeapReportIdR = undefined
