class BookmarksController
    constructor: () ->
        @input = document.querySelectorAll '.input'
        @input[0].addEventListener 'keyup', _.bind(@onKey, @)
        subscribe 'first.model', _.bind(@onEnter, @)
        publish 'inited.controller'

    onKey: (event) ->
        keyCode = event.which
        if keyCode in [58..57] or keyCode in [65..90]
            searches = @input[0].value.split(' ')
            publish 'key.controller', [searches]
        else if keyCode == 13
            publish 'enter.controller', [event.ctrlKey]

    onEnter: (url, isCtrlKey) ->
        if (isCtrlKey)
            window.open url
        else
            window.location = url
        url
