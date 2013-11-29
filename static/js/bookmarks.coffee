class Bookmarks
    constructor: () ->

    init: () ->
        @initModel()
        subscribe 'loaded.model', _.bind(@initRenderer, @)
        subscribe 'inited.renderer', _.bind(@initController, @)

    onKey: () ->
        searches = @controller.getSearches()
        results = _.map searches, @onSearch, @
        resultsArray = []
        _.each results, (resultsPart) ->
            _.each resultsPart, (result) ->
                resultsArray.push result
        resultsUniq = _.uniq(resultsArray)
        @renderer.render resultsUniq

    onSearch: (value) ->
        bookmarks = @model.get()
        @model.filter value

    initController: () ->
        @controller = new BookmarksController()
        @controller.init()
        subscribe 'key.controller', _.bind(@onKey, @)

    initRenderer: () ->
        @renderer = new BookmarksRenderer()
        @renderer.setModel(@model)
        @renderer.init()

    initModel: () ->
        @model = new BookmarksModel()
        @model.init()
