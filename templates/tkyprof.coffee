Batman.config.usePushState = false

# Controllers

class TKYProf extends Batman.App
  @root 'home#index'
  @resources 'projects'

class TKYProf.HomeController extends Batman.Controller
  routingKey: 'home'

  constructor: ->
    super
    @set 'projects', new TKYProf.ProjectPaginator

  index: ->
    @get('projects').toArray (projects) =>
      @set 'currentProjects', projects

class TKYProf.ProjectsController extends Batman.Controller
  routingKey: 'projects'

  constructor: ->
    super
    paginator = new TKYProf.ProjectPaginator
    @set 'projects', paginator
    # paginated view for projects
    @set 'projectsView', new TKYProf.PaginatedView
      paginator: paginator

  index: (params) ->
    console.log "TKYProf.ProjectsController#index"
    @render source: 'projects/index'

  show: (params) ->
    TKYProf.Project.find params.id, (err, project) =>
      console.log err if err
      console.log project.toJSON()
      @set 'currentProject', project
    @render source: 'projects/show'

# Models

class TKYProf.RestStorage extends Batman.RestStorage
  serializeAsForm: false
  recordJsonNamespace: -> null

class TKYProf.Project extends Batman.Model
  @resourceName: 'project'
  @encode 'name', 'createdAt', 'updatedAt'
  @persist TKYProf.RestStorage
  @url = 'projects'

# Paginators

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

# Views

class TKYProf.PaginatedView extends Batman.View
  constructor: ->
    super
    @set 'currentItems', new Batman.Set

  render: ->
    @feedItems()
    super

  feedItems: ->
    @get('paginator').toArray (newItems) =>
      currentItems = @get('currentItems')
      newItems.forEach (item) ->
        currentItems.add item

  nextPage: ->
    @get('paginator').nextPage()
    @feedItems()

# main

window.TKYProf = TKYProf
TKYProf.run()
