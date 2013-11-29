class BookmarksRenderer
    constructor: () ->
        subscribe 'loaded.model', _.bind(@render, @)
        subscribe 'filtered.model', _.bind(@render, @)
        publish 'inited.renderer'

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
        document.querySelectorAll('.bookmarks-list')[0].innerHTML = html.join('')
