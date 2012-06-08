module TKYProf.Controller.Project where
import Yesod.Content
import Yesod.Json (jsonToRepJson)
import Yesod.Persist (runDB)

import TKYProf.Controller.Internal
import TKYProf.Model

getProjectsR :: Handler RepJson
getProjectsR = do
  projects <- runDB $ selectList [] []
  jsonToRepJson (projects :: [Entity Project])

postProjectsR :: Handler RepJson
postProjectsR = undefined

getProjectIdR :: ProjectId -> Handler RepJson
getProjectIdR = undefined

deleteProjectIdR :: ProjectId -> Handler RepJson
deleteProjectIdR = undefined
