class TasselController
    constructor: () ->
        new Form()
        new Searchbar
        subscribe 'rendered.renderer', _.bind(@initBookmarks, @)
        subscribe 'first.model', _.bind(@onEnter, @)
        subscribe 'tagclick.controller', _.bind(@pubSearches, @)
        subscribe 'form.renderer', _.bind(@onFormRender, @)
        publish 'inited.controller'

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
            publish 'empty.searchbar'
        else if search.indexOf('http://') == 0 or search.indexOf('https://') == 0
            publish 'url.searchbar'
        else
            publish 'key.searchbar', [search]

    onFormRender: (wrapper) ->
        form = wrapper.querySelectorAll('.bookmark-form')
        form[0].addEventListener 'submit', _.bind(@onEditSubmit, @)

    onEditSubmit: (event) ->
        event.preventDefault()
        publish 'editsubmit.controller', [event]
