class BookmarkForm
    constructor: (wrapper, data) ->
        @_wrapper = wrapper
        @_data = data
        @render()

    getHtml: () ->
        template = [
            '<form class="bookmark-form">',
                '<input name="url" class="bookmark-link-edit" value="<%= url %>" autofocus="true" tabindex="5" disabled="disabled">',
                '<input name="title" class="bookmark-title-edit" value="<%= title %>" tabindex="6">',
                '<input name="tags" class="bookmark-tags-edit" value="<%= tags.join(\' \') %>" tabindex="7">',
                '<button class="bookmark-form-submit" type="submit" tabindex="8">✓</button>',
            '</form>'
        ]
        _.template template.join(''), @_data

    render: () ->
        @_wrapper.innerHTML = @getHtml()

        form = @_wrapper.querySelectorAll('.bookmark-form')[0]
        form.addEventListener 'submit', _.bind(@onSubmit, @)

    onSubmit: (event) ->
        event.preventDefault()
        publish 'edit.bookmark'
