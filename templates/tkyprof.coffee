Batman.config.usePushState = false

class TKYProf extends Batman.App
  @root 'home#all'

class TKYProf.HomeController extends Batman.Controller
  routingKey: 'home'

  constructor: ->
    super
    @set 'projects', new TKYProf.ProjectPaginator

  all: ->
    TKYProf.Project.load
    console.log "before"
    page = @get('projects.page')
    console.log "page: #{page}"
    @set 'currentProjects', @get('projects.toArray')
    console.log "after"

class TKYProf.RestStorage extends Batman.RestStorage
  serializeAsForm: false
  recordJsonNamespace: -> null

class TKYProf.Project extends Batman.Model
  @encode 'name', 'createdAt', 'updatedAt'
  @persist TKYProf.RestStorage
  @resourceName: 'project'
  @url = 'projects'

class TKYProf.ProjectPaginator extends Batman.ModelPaginator
  model: TKYProf.Project
  limit: 20

window.TKYProf = TKYProf
TKYProf.run()
