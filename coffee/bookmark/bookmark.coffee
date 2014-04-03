class Bookmark
    TEMPLATE: JST['handlebars/bookmark.hbs']


    # @param data [Object]
    constructor: (data) ->
        @_data = data
        @init()
        subscribe 'edit.bookmark', _.bind(@render, @)

    init: () ->
        @_wrapper = document.createElement('li')
        @_wrapper.className = 'bookmark-item'
        document.querySelectorAll('.bookmarks-list')[0].appendChild(@_wrapper)
        @render()

    render: () ->
        @_wrapper.innerHTML = @getHtml()
        @_wrapper.addEventListener 'click', _.bind(@onClick, @)

    getHtml: () ->
        @TEMPLATE @_data

    # @param event [Event]
    onClick: (event) ->
        element = event.target
        switch element.className
            when 'bookmark-tag-link' then @onTagClick(element)
            when 'bookmark-edit' then @onEditClick(element)
            when 'bookmark-remove' then @onRemoveClick()
            #TODO
            #else @onLinkClick(event.ctrlKey)

    # @param element [DOM Element]
    onTagClick: (element) ->
        tag = element.textContent
        publish 'tagclick.bookmark', [tag]

    onEditClick: () ->
        #TODO
        #@_wrapper.removeEventListener 'click', _.bind(@onClick, @)
        new BookmarkForm(@_wrapper, @_data)

    onRemoveClick: () ->
        @_wrapper.remove()
        #publish 'remove.bookmark', [@_data.url]

    ###
    onLinkClick: (isCtrlKey) ->
        if (isCtrlKey)
            window.open @_data.url
        else
            window.location = @_data.url
    ###
