module TKYProf.Controller.Project where
import Yesod.Content
import Yesod.Json (jsonToRepJson)
import Yesod.Persist (runDB)

import TKYProf.Controller.Internal
import TKYProf.Model

getProjectsR :: Handler RepJson
getProjectsR = pagenator 0 20 $ \pagenate -> do
  projects <- runDB $ selectList [] (pagenate [])
  jsonToRepJson (projects :: [Entity Project])

postProjectsR :: Handler RepJson
postProjectsR = undefined

getProjectIdR :: ProjectId -> Handler RepJson
getProjectIdR = undefined

deleteProjectIdR :: ProjectId -> Handler RepJson
deleteProjectIdR = undefined
