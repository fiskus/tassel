class BookmarksController
    constructor: () ->

    init: () ->
        @input = document.querySelectorAll '.input'
        @input[0].addEventListener 'keyup', _.bind(@onKey, @)
        publish 'inited.controller'

    onKey: (event) ->
        @searches = @input[0].value.split(' ')
        publish 'key.controller'

    getSearches: () ->
        @searches
