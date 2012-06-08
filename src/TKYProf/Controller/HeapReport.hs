module TKYProf.Controller.HeapReport where
import Yesod.Content
import Yesod.Core

import TKYProf.Model

postHeapReportsR :: ProjectId -> GHandler master sub RepJson
postHeapReportsR = undefined

getHeapReportIdR :: ProjectId -> HeapReportId -> GHandler master sub RepJson
getHeapReportIdR = undefined

deleteHeapReportIdR :: ProjectId -> HeapReportId -> GHandler master sub RepJson
deleteHeapReportIdR = undefined

