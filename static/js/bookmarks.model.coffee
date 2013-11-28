class BookmarksModel
    constructor: () ->

    init: () ->
        @load()

    load: () ->
        @save()

    save: () ->
        @bookmarks = [{
            url: 'https://ostrovok.ru',
            title: 'ostrovok.ru',
            tags: [
                'travel',
                'application',
                'russian',
                'job'
            ]
        }, {
            url: 'http://opennet.ru',
            title: 'opennet.ru',
            tags: [
                'news',
                'linux',
                'freebsd',
                'openbsd'
            ]
        }, {
            url: 'https://news.ycombinator.com',
            title: 'news.ycombinator.com',
            tags: [
                'news'
            ]
        }]

    get: () ->
        @bookmarks

    filter: (value) ->
        results = []
        _.each @bookmarks, (bookmark) ->
            if bookmark.title.indexOf(value) > -1
                results.push(bookmark)
        results
