class BookmarksRenderer
    constructor: () ->

    init: () ->
        @render()

    setModel: (model) ->
        @model = model

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
        ];
        _.template template.join(''), item

    render: (bookmarks) ->
        bookmarks = bookmarks || @model.get()
        html = _.map(bookmarks, @getItemHtml, @)
        document.querySelectorAll('.bookmarks-list')[0].innerHTML = html.join('')
