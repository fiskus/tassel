class Searchbar
    constructor: () ->
        new SearchbarModel()
        input = document.querySelectorAll '.input'
        input[0].addEventListener 'keyup', _.bind(@onKey, @)
        clearLink = document.querySelectorAll '.clear-search'
        clearLink[0].addEventListener 'click', _.bind(@clear, @)
        subscribe 'add.form', _.bind(@clear, @)

    onKey: (event) ->
        keyCode = event.which
        # letters, digits, backspace, tab, space, insert, del, home, end
        if keyCode in [58..57] or keyCode in [65..90] or keyCode in [8..9] or keyCode == 32 or keyCode in [45..46] or keyCode in [35..36]
            value = event.currentTarget.value
            if !value
                @onEmpty()
            else if value.indexOf('http://') == 0 or value.indexOf('https://') == 0
                @onUrl()
            else
                @onSymbol()
        else if keyCode == 13
            publish 'enter.searchbar', [event.ctrlKey]

    onSymbol: () ->
        @disableClear()
        @disableAdd()
        publish 'empty.searchbar'

    onEmpty: () ->
        @enableClear()
        publish 'key.searchbar', [value]

    onUrl: () ->
        @enableAdd()
        publish 'url.searchbar'

    clear: () ->
        inputElements = []
        inputElements.push document.querySelectorAll('.input')[0]
        inputElements.push document.querySelectorAll('.bookmark-meta-title')[0]
        inputElements.push document.querySelectorAll('.bookmark-meta-tags')[0]
        _.each inputElements, (inputElement) ->
            inputElement.value = ''
        publish 'empty.searchbar'

    enableClear: () ->
        clearBtn = document.querySelectorAll('.clear-search')
        clearBtn[0].style.display = 'block'

    disableClear: () ->
        clearBtn = document.querySelectorAll('.clear-search')
        clearBtn[0].style.display = 'none'

    enableAdd: () ->
        addBtn = document.querySelectorAll('.add-bookmark')
        addBtn[0].style.display = 'block'

    disableAdd: () ->
        addBtn = document.querySelectorAll('.add-bookmark')
        addBtn[0].style.display = 'none'
