class Bookmarks
    constructor: () ->

    init: () ->
        @initModel()
        @initRenderer()
        @input = document.querySelectorAll '.input'
        @input[0].addEventListener 'keyup', _.bind(@onKey, @)

    onKey: (event) ->
        searches = @input[0].value.split(' ')
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

    initRenderer: () ->
        @renderer = new BookmarksRenderer()
        @renderer.setModel(@model)
        @renderer.init()

    initModel: () ->
        @model = new BookmarksModel()
        @model.init()
