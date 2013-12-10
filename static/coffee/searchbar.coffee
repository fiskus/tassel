class Searchbar
    constructor: () ->
        new SearchbarModel()
        input = document.querySelectorAll '.input'
        input[0].addEventListener 'keyup', _.bind(@onKey, @)
        clearLink = document.querySelectorAll '.clear-search'
        clearLink[0].addEventListener 'click', _.bind(@clear, @)
        subscribe 'add.formmodel', _.bind(@clear, @)
        subscribe 'key.searchbar', _.bind(@enableClear, @)
        subscribe 'empty.searchbar', _.bind(@disableClear, @)

    onKey: (event) ->
        keyCode = event.which
        # letters, digits, backspace, tab, space, insert, del, home, end
        if keyCode in [58..57] or keyCode in [65..90] or keyCode in [8..9] or keyCode == 32 or keyCode in [45..46] or keyCode in [35..36]
            value = event.currentTarget.value
            if !value
                publish 'empty.searchbar'
            else if value.indexOf('http://') == 0 or value.indexOf('https://') == 0
                publish 'url.searchbar'
            else
                publish 'key.searchbar', [value]
        else if keyCode == 13
            publish 'enter.searchbar', [event.ctrlKey]

    clear: () ->
        inputElements = []
        inputElements.push document.querySelectorAll('.input')[0]
        inputElements.push document.querySelectorAll('.bookmark-meta-title')[0]
        inputElements.push document.querySelectorAll('.bookmark-meta-tags')[0]
        _.each inputElements, (inputElement) ->
            inputElement.value = ''
        publish 'empty.searchbar'

    enableClear: () ->
        clearLink = document.querySelectorAll('.clear-search')
        clearLink[0].style.display = 'block'

    disableClear: () ->
        clearLink = document.querySelectorAll('.clear-search')
        clearLink[0].style.display = 'none'
