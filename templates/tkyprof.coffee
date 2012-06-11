Batman.config.usePushState = false

class TKYProf extends Batman.App

class TKYProf.HomeController extends Batman.Controller
  projects:

class TKYProf.RestStorage extends Batman.RestStorage
  serializeAsForm: false
  recordJsonNamespace: -> null

class TKYProf.Project extends Batman.Model
  @url = "projects"
  @persist TKYProf.RestStorage
  @encode 'name', 'createdAt', 'updatedAt'

class TKYProf.ProjectPaginator extends Batman.ModelPaginator
  model: TKYProf.Project

window.TKYProf = TKYProf
