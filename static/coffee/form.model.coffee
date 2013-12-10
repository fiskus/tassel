class FormModel
    constructor: () ->
        subscribe 'submit.form', _.bind(@onSubmit, @)

    addBookmark: () ->
        url = '/add/'
        options =
            cache: true
        onSuccess = _.bind(@onPost, @)
        qwest.post(url, bookmark, options).success(onSuccess)

    onSubmit: (event) ->
        bookmark = @serialize event.currentTarget
        bookmark = @validate bookmark
        if bookmark
            @addBookmark(bookmark)

    serialize: (form) ->
        serialized = {}
        _.each form, (element) ->
            name = element.name
            value = element.value
            if value
                if name == 'tags'
                    serialized[name] = value.split(' ')
                else
                    serialized[name] = value
        serialized

    validate: (data) ->
        isValid = true
        if !(data.url.indexOf('http://') == 0 or data.url.indexOf('https://') == 0)
            isValid = false
        if !data.title
            isValid = false
        if !data.tags || !data.tags.length
            isValid = false
        if isValid then data else false

    onPost: (data) ->
        publish 'add.formmodel', [data.bookmark]
