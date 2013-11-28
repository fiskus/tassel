class Bookmarks
    constructor: () ->

    init: () ->
        @initModel()
        @initRenderer()
        @input = document.querySelectorAll '.input'
        @input[0].addEventListener 'keyup', _.bind(@onKey, @)

    onKey: (event) ->
        searches = @input[0].value.split(' ')
        _.each searches, @onSearch, @

    onSearch: (value) ->
        bookmarks = @model.get()
        results = []
        _.each bookmarks, (bookmark) ->
            if bookmark.title.indexOf(value) > -1
                results.push(bookmark)
        @renderer.render results

    initRenderer: () ->
        @renderer = new BookmarksRenderer()
        @renderer.setModel(@model)
        @renderer.init()

    initModel: () ->
        @model = new BookmarksModel()
        @model.init()
