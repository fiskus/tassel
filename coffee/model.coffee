class TasselModel
    constructor: () ->
        @load()
        subscribe 'key.searchbar', _.bind(@onInput, @)
        subscribe 'empty.searchbar', _.bind(@onEmptySearch, @)
        subscribe 'enter.searchbar', _.bind(@processFirstBookmark, @)
        subscribe 'editsubmit.controller', _.bind(@edit, @)
        subscribe 'remove.renderer', _.bind(@remove, @)
        subscribe 'add.form', _.bind(@onAdd, @)

    # @param bookmark [Object]
    onAdd: (bookmark) ->
        #TODO: push at first position
        @_bookmarks.push bookmark

    load: () ->
        url = '/get/'
        options =
            cache: true
        onSuccess = _.bind(@save, @)
        qwest.get(url, {}, options).success(onSuccess)

    # @param data [Object]
    save: (data) ->
        bookmarks = data.bookmarks.reverse()
        @setBookmarks bookmarks
        publish 'loaded.model', [bookmarks]

    # @param url [String]
    remove: (url) ->
        bookmarks = _.clone @getBookmarks()
        index = _.findIndex bookmarks, (bookmark) ->
            bookmark.url == url
        url = '/delete/'
        options =
            cache: true
        qwest.post(url, bookmarks[index], options)
        delete bookmarks[index]
        bookmarks = _.compact bookmarks
        @setBookmarks bookmarks

    onEmptySearch: (search) ->
        publish 'filtered.model', [@getBookmarks()]

    onInput: (search) ->
        values = search.split(' ')
        @search values

    # @param values [Array]
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
        """
        WTF?
        if !bookmark
            @addFromInput()
            return false
        """
        url = bookmark.url
        publish 'first.model', [url, isCtrlKey]
        url

    getBookmarks: () ->
        @_bookmarks

    getFiltered: () ->
        @_filteredBookmarks

    setBookmarks: (bookmarks) ->
        @_bookmarks = bookmarks

    setFiltered: (filteredBookmarks) ->
        publish 'filtered.model', [filteredBookmarks]
        @_filteredBookmarks = filteredBookmarks

    validate: (data) ->
        isValid = true
        if !(data.url.indexOf('http://') == 0 or data.url.indexOf('https://') == 0)
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

    edit: (event) ->
        bookmark = @serialize event.currentTarget
        bookmark = @validate bookmark
        if !bookmark
            return false
        url = '/edit/'
        options =
            cache: true
        onSuccess = _.bind(@onPostEdit, @)
        qwest.post(url, bookmark, options).success(onSuccess)

    onPostEdit: (data) ->
        publish 'edit.model', [data.bookmark]
