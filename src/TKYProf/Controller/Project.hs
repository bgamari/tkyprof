module TKYProf.Controller.Project where
import Yesod.Content
import Yesod.Core
import Yesod.Json (jsonToRepJson)
import Yesod.Persist (runDB)

import TKYProf.Controller.Internal
import TKYProf.Model

getProjectsR :: Handler RepJson
getProjectsR = do
  projects <- runDB $ selectList [] []
  jsonToRepJson (projects :: [Entity Project])

postProjectsR :: GHandler master sub RepJson
postProjectsR = undefined

getProjectIdR :: ProjectId -> GHandler master sub RepJson
getProjectIdR = undefined

deleteProjectIdR :: ProjectId -> GHandler master sub RepJson
deleteProjectIdR = undefined
