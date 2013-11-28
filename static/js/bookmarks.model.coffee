class BookmarksModel
    constructor: () ->

    init: () ->
        @load()

    load: () ->
        @save()

    save: () ->
        @bookmarks = [{
                url: 'https://ostrovok.ru',
                title: 'Островок.ру',
                tags: [
                    'one',
                    'two',
                    'three'
                ]
            }, {
                url: 'https://opennet.ru',
                title: 'Опеннет',
                tags: [
                    'one',
                    'three'
                ]
        }]

    get: () ->
        @bookmarks
