class BookmarksRenderer
    constructor: () ->

    init: () ->
        @render()

    setModel: (model) ->
        @model = model

    getItemHtml: (item) ->
        template = [];
        template.push('<li class="bookmark-item">');
        template.push('<a class="bookmark-link" href="<%= url %>"><%= title %></a>');
        template.push('<ul class="bookmark-tags">');
        template.push('<% _.each(tags, function(tag) { %>');
        template.push('<li class="bookmark-tag-item">');
        template.push('<span class="bookmark-tag-link"><%= tag %></span>');
        template.push('</li>');
        template.push('<% }); %>');
        template.push('</ul>');
        template.push('</li>');
        _.template template.join(''), item

    render: (bookmarks) ->
        bookmarks = bookmarks || @model.get()
        html = _.map(bookmarks, @getItemHtml, @)
        document.querySelectorAll('.bookmarks-list')[0].innerHTML = html.join('')
