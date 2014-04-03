class BookmarkForm
    TEMPLATE: JST['handlebars/form.hbs']

    # @param wrapper {DOM Element}
    # @param data {Object}
    constructor: (wrapper, data) ->
        @_wrapper = wrapper
        @_data = data
        @render()

    getHtml: () ->
        data =
            url: @_data.url
            title: @_data.title
            tags: @_data.tags.join(' ')
        @TEMPLATE(data)

    render: () ->
        @_wrapper.innerHTML = @getHtml()

        form = @_wrapper.querySelectorAll('.bookmark-form')[0]
        form.addEventListener 'submit', _.bind(@onSubmit, @)

    # @param event {Event}
    onSubmit: (event) ->
        event.preventDefault()
        publish 'edit.bookmark'
