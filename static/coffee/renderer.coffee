class BookmarksRenderer
    constructor: () ->
        subscribe 'loaded.model', _.bind(@render, @)
        subscribe 'filtered.model', _.bind(@render, @)
        subscribe 'url.controller', _.bind(@showMeta, @)
        subscribe 'empty.controller', _.bind(@hideMeta, @)
        subscribe 'key.controller', _.bind(@showClearLink, @)
        subscribe 'empty.controller', _.bind(@hideClearLink, @)
        subscribe 'edit.controller', _.bind(@edit, @)
        subscribe 'remove.controller', _.bind(@remove, @)
        publish 'inited.renderer'

    showMeta: () ->
        metaBox = document.querySelectorAll('.bookmark-meta')
        metaBox[0].style.display = 'block'

    hideMeta: () ->
        metaBox = document.querySelectorAll('.bookmark-meta')
        metaBox[0].style.display = 'none'

    showClearLink: () ->
        clearLink = document.querySelectorAll('.clear-search')
        clearLink[0].style.display = 'block'

    hideClearLink: () ->
        clearLink = document.querySelectorAll('.clear-search')
        clearLink[0].style.display = 'none'

    edit: (bookmark) ->
        console.log bookmark

    remove: (bookmark) ->
        url = bookmark.querySelectorAll('.bookmark-link')[0].href
        bookmark.remove()
        publish 'remove.renderer', [url]

    getItemHtml: (item) ->
        template = [
            '<li class="bookmark-item">',
                '<a class="bookmark-link" href="<%= url %>"><%= title %></a>',
                '<ul class="bookmark-tags">',
                    '<% _.each(tags, function(tag) { %>',
                        '<li class="bookmark-tag-item">',
                            '<a class="bookmark-tag-link" href="#<%= tag %>">',
                                '<%= tag %>',
                            '</a>',
                        '</li>',
                    '<% }); %>',
                '</ul>',
                '<span class="bookmark-control">'
                    '<button class="bookmark-edit">✎</button>',
                    '<button class="bookmark-remove">⊗</button>',
                '</span>'
            '</li>'
        ]
        _.template template.join(''), item

    render: (bookmarks) ->
        html = _.map(bookmarks, @getItemHtml, @)
        element = document.querySelectorAll('.bookmarks-list')[0]
        element.innerHTML = html.join('')
        publish 'rendered.renderer'
