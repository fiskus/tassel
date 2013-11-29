class BookmarksController
    constructor: () ->
        @initInput()
        subscribe 'rendered.renderer', _.bind(@initLinks, @)
        subscribe 'first.model', _.bind(@onEnter, @)
        subscribe 'tagclick.controller', _.bind(@pubSearches, @)
        publish 'inited.controller'

    initInput: () ->
        input = document.querySelectorAll '.input'
        input[0].addEventListener 'keyup', _.bind(@onKey, @)

    initLinks: () ->
        links = document.querySelectorAll '.bookmark-tag-link'
        listenLink = (link) ->
            link.addEventListener 'click', _.bind(@onTagClick, @)
        _.each links, listenLink, @

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
        input[0].value = tag
        @pubSearches(input[0])

    pubSearches: (inputElement) ->
        searches = inputElement.value.split(' ')
        publish 'key.controller', [searches]
