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
        @bookmarks = data.bookmarks
        publish 'loaded.model', [@bookmarks]
        @bookmarks

    get: () ->
        @bookmarks

    multipleFilter: (values) ->
        results = _.map values, @filter, @
        allResults = _.flatten(results, true)
        uniqResults = _.uniq(allResults)
        returnResults = []
        if uniqResults.length
            returnResults = uniqResults
        else
            returnResults = @bookmarks
        publish 'filtered.model', [returnResults]
        returnResults

    filter: (value) ->
        if !value
            return []
        value = value.toLowerCase()
        results = []
        _.each @bookmarks, (bookmark) ->
            title = bookmark.title.toLowerCase()
            if title.indexOf(value) > -1
                results.push(bookmark)
            _.each bookmark.tags, (tag) ->
                if tag.toLowerCase().indexOf(value) > -1
                    results.push(bookmark)
        @filteredBookmarks = _.uniq(results)
        _.uniq(@filteredBookmarks)

    processFirstBookmark: (isCtrlKey) ->
        bookmark = _.first(@filteredBookmarks || @bookmarks)
        url = bookmark.url
        publish 'first.model', [url, isCtrlKey]
        url
