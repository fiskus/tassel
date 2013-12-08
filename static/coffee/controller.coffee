class BookmarksController
    constructor: () ->
        @initInput()
        subscribe 'rendered.renderer', _.bind(@initBookmarks, @)
        subscribe 'first.model', _.bind(@onEnter, @)
        subscribe 'posted.model', _.bind(@clearInput, @)
        subscribe 'tagclick.controller', _.bind(@pubSearches, @)
        subscribe 'form.renderer', _.bind(@onFormRender, @)
        publish 'inited.controller'

    initInput: () ->
        input = document.querySelectorAll '.input'
        input[0].addEventListener 'keyup', _.bind(@onKey, @)
        form = document.querySelectorAll '.form'
        form[0].addEventListener 'submit', _.bind(@onSubmit, @)
        clearLink = document.querySelectorAll '.clear-search'
        clearLink[0].addEventListener 'click', _.bind(@clearInput, @)

    initBookmarks: () ->
        bookmarks = document.querySelectorAll '.bookmark-item'
        _.each bookmarks, _.bind(@initBookmark, @)
        bookmarks

    initBookmark: (bookmark) ->
        @initTags(bookmark)
        @initButtons(bookmark)
        bookmark

    initButtons: (bookmark) ->
        editBtn = bookmark.querySelectorAll '.bookmark-edit'
        removeBtn = bookmark.querySelectorAll '.bookmark-remove'
        onEdit = (event) ->
            @edit bookmark
        editBtn[0].addEventListener 'click', _.bind(onEdit, @)
        onRemove = (event) ->
            @remove bookmark
        removeBtn[0].addEventListener 'click', _.bind(onRemove, @)

    initTags: (bookmark) ->
        links = bookmark.querySelectorAll '.bookmark-tag-link'
        listenLink = (link) ->
            link.addEventListener 'click', _.bind(@onTagClick, @)
        _.each links, listenLink, @

    edit: (bookmark) ->
        publish 'edit.controller', [bookmark]

    remove: (bookmark) ->
        publish 'remove.controller', [bookmark]

    onKey: (event) ->
        keyCode = event.which
        if keyCode in [58..57] or keyCode in [65..90] or keyCode == 8
            @pubSearches(event.currentTarget)
        else if keyCode == 13
            publish 'enter.controller', [event.ctrlKey]

    onEnter: (url, isCtrlKey) ->
        if (isCtrlKey)
            window.open url
        else
            window.location = url
        url

    onTagClick: (event) ->
        link = event.currentTarget
        tag = link.textContent
        input = document.querySelectorAll '.input'
        input[0].value = '#' + tag
        @pubSearches(input[0])

    pubSearches: (inputElement) ->
        search = inputElement.value
        if !search
            publish 'empty.controller'
        else if search.indexOf('http://') == 0 or search.indexOf('https://') == 0
            publish 'url.controller'
        else
            publish 'key.controller', [search]

    onSubmit: (event) ->
        event.preventDefault()
        publish 'add.controller', [event]

    clearInput: () ->
        inputUrl = document.querySelectorAll('.input')[0]
        inputTitle = document.querySelectorAll('.bookmark-meta-title')[0]
        inputTags = document.querySelectorAll('.bookmark-meta-tags')[0]
        inputUrl.value = ''
        inputTitle.value = ''
        inputTags.value = ''
        publish 'empty.controller'

    onFormRender: (wrapper) ->
        form = wrapper.querySelectorAll('.bookmark-form')
        form[0].addEventListener 'submit', _.bind(@onEditSubmit, @)

    onEditSubmit: (event) ->
        event.preventDefault()
        publish 'editsubmit.controller', [event]
