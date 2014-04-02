class Form
    constructor: () ->
        new FormModel()
        form = document.querySelectorAll '.form'
        form[0].addEventListener 'submit', _.bind(@onSubmit, @)
        subscribe 'url.searchbar', _.bind(@showMeta, @)
        subscribe 'empty.searchbar', _.bind(@hideMeta, @)

    onSubmit: (event) ->
        event.preventDefault()
        publish 'submit.form', [event]

    showMeta: () ->
        metaBox = document.querySelectorAll('.bookmark-meta')
        metaBox[0].style.display = 'block'

    hideMeta: () ->
        metaBox = document.querySelectorAll('.bookmark-meta')
        metaBox[0].style.display = 'none'
