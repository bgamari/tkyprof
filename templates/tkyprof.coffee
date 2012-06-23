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
    # paginated view for projects
    @set 'projectsView', new TKYProf.PaginatedView
      paginator: new TKYProf.ProjectPaginator
        limit: 50
      autoLoad: true

  index: (params) ->
    @render source: 'projects/index'

  show: (params) ->
    TKYProf.Project.find params.id, (err, project) =>
      console.log err if err
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
  @hasMany 'timeAllocReports'
  @hasMany 'heapReports'
  @hasMany 'eventReports'

class TKYProf.BaseReport extends Batman.Model
  @encode 'projectId', 'commandLine', 'rawData', 'createdAt'
  @persist TKYProf.RestStorage
  @belongsTo 'project'

class TKYProf.TimeAllocReport extends TKYProf.BaseReport
  @resourceName: 'timeAllocReport'
  @url = 'timealloc'

class TKYProf.HeapReport extends TKYProf.BaseReport
  @resourceName: 'heapReport'
  @url = 'heap'

class TKYProf.EventReport extends TKYProf.BaseReport
  @resourceName: 'eventReport'
  @url = 'event'

# Paginators

class TKYProf.ModelPaginator extends Batman.ModelPaginator
  constructor: ->
    super
    @set 'loading', false

  toArray: (callback) ->
    cache = @get('cache')
    offset = @get('offset')
    limit = @get('limit')
    if cache?.coversOffsetAndLimit(offset, limit)
      callback(cache.itemsForOffsetAndLimit(offset, limit) or [])
    else
      @observe 'cache', (newCache) ->
        callback(newCache.itemsForOffsetAndLimit(offset, limit) or [])
        @set 'loading', false
      @set 'loading', true
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
    @loadItems()
    if @get 'autoLoad'
      $(window).scroll @loadOnScroll
    super

  loadOnScroll: =>
    return if @get 'paginator.loading'
    node = $(@get 'node')
    nodeBottom = node.offset().top + node.height()
    windowBottom = $(window).scrollTop() + $(window).height()
    @nextPage() if nodeBottom < windowBottom

  loadItems: ->
    @get('paginator').toArray (newItems) =>
      currentItems = @get('currentItems')
      newItems.forEach (item) ->
        currentItems.add item

  nextPage: ->
    @get('paginator').nextPage()
    @loadItems()

# main

window.TKYProf = TKYProf
TKYProf.run()
