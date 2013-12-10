class Tassel
    constructor: () ->
        new Form()
        new Searchbar
        new TasselModel()

        renderBookmarks = (bookmarks) ->
            _.each bookmarks, (data) ->
                new Bookmark(data)
        subscribe 'loaded.model', renderBookmarks
        subscribe 'filtered.model', renderBookmarks
