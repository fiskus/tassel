class BookmarksRenderer
    constructor: () ->
        subscribe 'loaded.model', _.bind(@render, @)
        subscribe 'filtered.model', _.bind(@render, @)
        subscribe 'url.controller', _.bind(@onUri, @)
        publish 'inited.renderer'

    onUri: () ->
        @showMeta()

    showMeta: () ->
        metaBox = document.querySelectorAll('.bookmark-meta')
        metaBox[0].style.display = 'block'

    getItemHtml: (item) ->
        template = [
            '<li class="bookmark-item">',
                '<a class="bookmark-link" href="<%= url %>"><%= title %></a>',
                '<ul class="bookmark-tags">',
                    '<% _.each(tags, function(tag) { %>',
                        '<li class="bookmark-tag-item">',
                            '<a class="bookmark-tag-link" href="#<%= tag %>"><%= tag %></a>',
                        '</li>',
                    '<% }); %>',
                '</ul>',
            '</li>'
        ]
        _.template template.join(''), item

    render: (bookmarks) ->
        html = _.map(bookmarks, @getItemHtml, @)
        element = document.querySelectorAll('.bookmarks-list')[0]
        element.innerHTML = html.join('')
        publish 'rendered.renderer'
