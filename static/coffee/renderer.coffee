class TasselRenderer
    constructor: () ->
        subscribe 'loaded.model', _.bind(@render, @)
        subscribe 'filtered.model', _.bind(@render, @)
        subscribe 'edit.controller', _.bind(@edit, @)
        subscribe 'remove.controller', _.bind(@remove, @)
        subscribe 'edit.model', _.bind(@onEditSuccess, @)
        publish 'inited.renderer'

    edit: (bookmark) ->
        url = bookmark.querySelectorAll('.bookmark-link')[0].getAttribute('href')
        title = bookmark.querySelectorAll('.bookmark-link')[0].innerHTML
        tags = _.map bookmark.querySelectorAll('.bookmark-tag-link'), (tag) ->
            tag.innerHTML
        bookmarkData =
            url: url,
            title: title,
            tags: tags
        html = @getFormHtml bookmarkData
        bookmark.innerHTML = html
        publish 'form.renderer', [bookmark]

    remove: (bookmark) ->
        url = bookmark.querySelectorAll('.bookmark-link')[0].getAttribute('href')
        bookmark.remove()
        publish 'remove.renderer', [url]

    getFormHtml: (data) ->
        template = [
            '<form class="bookmark-form">',
                '<input name="url" class="bookmark-link-edit" value="<%= url %>" autofocus="true" tabindex="5" disabled="disabled">',
                '<input name="title" class="bookmark-title-edit" value="<%= title %>" tabindex="6">',
                '<input name="tags" class="bookmark-tags-edit" value="<%= tags.join(\' \') %>" tabindex="7">',
                '<button class="bookmark-form-submit" type="submit" tabindex="8">✓</button>',
            '</form>'
        ]
        _.template template.join(''), data

    getBookmarkHtml: (item) ->
        template = [
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
        ]
        _.template template.join(''), item

    getItemHtml: (item) ->
        bookmarkHtml = @getBookmarkHtml(item)
        data =
            bookmark: bookmarkHtml
        template = '<li class="bookmark-item"><%= bookmark %></li>'
        _.template template, data

    render: (bookmarks) ->
        html = _.map(bookmarks, @getItemHtml, @)
        element = document.querySelectorAll('.bookmarks-list')[0]
        element.innerHTML = html.join('')
        publish 'rendered.renderer'

    onEditSuccess: (bookmark) ->
        html = @getBookmarkHtml bookmark
        wrapper = document.querySelectorAll('.bookmark-form')[0].parentNode
        wrapper.innerHTML = html
