class BookmarksModel
    constructor: () ->
        @load()
        subscribe 'key.controller', _.bind(@onInput, @)
        subscribe 'empty.controller', _.bind(@onEmptyInput, @)
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
        bookmarks = data.bookmarks.reverse()
        @setBookmarks(bookmarks)

    onEmptyInput: (search) ->
        publish 'filtered.model', [@getBookmarks()]

    onInput: (search) ->
        values = search.split(' ')
        @search values

    search: (values) ->
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
            if value.indexOf('#') == 0
                tagSearch = value.substring 1
                _.each bookmark.tags, (tag) ->
                    if tag.toLowerCase().indexOf(tagSearch) > -1
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

    validate: (data) ->
        isValid = true
        if data.url.indexOf('http://') != 0
            isValid = false
        if !data.title
            isValid = false
        if !data.tags || !data.tags.length
            isValid = false
        if isValid then data else false

    serialize: (form) ->
        serialized = {}
        _.each form, (element) ->
            name = element.name
            value = element.value
            if value
                if name == 'tags'
                    serialized[name] = value.split(' ')
                else
                    serialized[name] = value
        serialized

    addFromInput: (event) ->
        bookmark = @serialize event.currentTarget
        bookmark = @validate bookmark
        if !bookmark
            return false
        ajaxSettings =
            context: @
            data: bookmark
            type: 'post'
            success: @onPost
            url: '/post/'
        $.ajax ajaxSettings

    onPost: (data) ->
        console.log data
