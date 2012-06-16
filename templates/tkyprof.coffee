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
    @get('projects').toArray (projects) =>
      @set 'currentProjects', projects
    console.log "after"

class TKYProf.RestStorage extends Batman.RestStorage
  serializeAsForm: false
  recordJsonNamespace: -> null

class TKYProf.Project extends Batman.Model
  @encode 'name', 'createdAt', 'updatedAt'
  @persist TKYProf.RestStorage
  @resourceName: 'project'
  @url = 'projects'

class TKYProf.ModelPaginator extends Batman.ModelPaginator
  toArray: (callback) ->
    cache = @get('cache')
    offset = @get('offset')
    limit = @get('limit')
    if cache?.coversOffsetAndLimit(offset, limit)
      callback(cache.itemsForOffsetAndLimit(offset, limit) or [])
    else
      @observe 'cache', (newCache) ->
        callback(newCache.itemsForOffsetAndLimit(offset, limit) or [])
      @_load(offset, limit)

class TKYProf.ProjectPaginator extends TKYProf.ModelPaginator
  model: TKYProf.Project
  limit: 20

window.TKYProf = TKYProf
TKYProf.run()
