class BookmarksModel
    constructor: () ->

    init: () ->
        @load()
        publish 'inited.model'

    load: () ->
        ajaxSettings =
            url: '/get/'
            method: 'get'
            context: @
            success: @save
        $.ajax ajaxSettings

    save: (data) ->
        @bookmarks = data.bookmarks
        publish 'loaded.model'

    get: () ->
        @bookmarks

    filter: (value) ->
        value = value.toLowerCase()
        results = []
        _.each @bookmarks, (bookmark) ->
            if bookmark.title.toLowerCase().indexOf(value) > -1
                results.push(bookmark)
            _.each bookmark.tags, (tag) ->
                if tag.toLowerCase().indexOf(value) > -1
                    results.push(bookmark)
        results
