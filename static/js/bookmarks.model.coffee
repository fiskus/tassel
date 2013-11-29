class BookmarksModel
    constructor: () ->
        @load()
        subscribe 'key.controller', _.bind(@multipleFilter, @)
        subscribe 'enter.controller', _.bind(@processFirstBookmark, @)
        publish 'inited.model'

    load: () ->
        ajaxSettings =
            url: '/get/'
            method: 'get'
            context: @
            success: @save
        $.ajax ajaxSettings

    save: (data) ->
        bookmarks = data.bookmarks
        @setBookmarks(bookmarks)

    multipleFilter: (values) ->
        rawResults = _.map values, @filter, @
        allResults = _.flatten(rawResults, true)
        uniqResults = _.uniq(allResults)
        results = if uniqResults.length then uniqResults else @getBookmarks()
        @setFiltered(results)

    filter: (value) ->
        if !value
            return []
        value = value.toLowerCase()
        results = []
        _.each @getBookmarks(), (bookmark) ->
            title = bookmark.title.toLowerCase()
            if title.indexOf(value) > -1
                results.push(bookmark)
            _.each bookmark.tags, (tag) ->
                if tag.toLowerCase().indexOf(value) > -1
                    results.push(bookmark)
        _.uniq(results)

    processFirstBookmark: (isCtrlKey) ->
        bookmark = _.first(@getFiltered())
        url = bookmark.url
        publish 'first.model', [url, isCtrlKey]
        url

    getBookmarks: () ->
        @_bookmarks

    getFiltered: () ->
        @_filteredBookmarks || @_bookmarks

    setBookmarks: (bookmarks) ->
        publish 'loaded.model', [bookmarks]
        @_bookmarks = bookmarks

    setFiltered: (bookmarks) ->
        publish 'filtered.model', [bookmarks]
        @_filteredBookmarks = bookmarks
