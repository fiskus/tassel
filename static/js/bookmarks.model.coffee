class BookmarksModel
    constructor: () ->
        @load()
        subscribe 'key.controller', _.bind(@multipleFilter, @)
        subscribe 'enter.controller', _.bind(@processFirstBookmark, @)
        subscribe 'add.controller', _.bind(@addFromInput, @)
        publish 'inited.model'

    load: () ->
        ajaxSettings =
            context: @
            type: 'get'
            success: @save
            url: '/get/'
        $.ajax ajaxSettings

    save: (data) ->
        bookmarks = data.bookmarks
        @setBookmarks(bookmarks)

    multipleFilter: (values) ->
        rawResults = _.map values, @filter, @
        allResults = _.flatten(rawResults, true)
        uniqResults = _.uniq(allResults)
        results = uniqResults
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
        if !bookmark
            @addFromInput()
            return false
        url = bookmark.url
        publish 'first.model', [url, isCtrlKey]
        url

    getBookmarks: () ->
        @_bookmarks

    getFiltered: () ->
        @_filteredBookmarks

    setBookmarks: (bookmarks) ->
        publish 'loaded.model', [bookmarks]
        @_bookmarks = bookmarks

    setFiltered: (filteredBookmarks) ->
        publish 'filtered.model', [filteredBookmarks]
        @_filteredBookmarks = filteredBookmarks

    validate: (string) ->
        if string.indexOf('http://') < 0
            return false
        string

    serialize: (string) ->
        data = string.split(',')
        url = data[0].trim()
        title = data[1].trim()
        tags = _.compact data[2].split(' ')
        serialized =
            url: url
            title: title
            tags: tags

    addFromInput: () ->
        input = document.querySelectorAll '.input'
        value = input[0].value
        bookmarkData = @validate value
        if !bookmarkData
            return false
        bookmark = @serialize bookmarkData
        ajaxSettings =
            context: @
            data: bookmark
            type: 'post'
            success: @onPost
            url: '/post/'
        $.ajax ajaxSettings

    onPost: (data) ->
        console.log data
