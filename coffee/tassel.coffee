# Tassel app
# @author Maxim Chervonny <fiskus@chervonny.ru>
class Tassel
    constructor: () ->
        # Initiate Form, Searchbar and TasselModel classes
        new Form()
        new Searchbar
        new TasselModel()

        renderBookmarks = (bookmarks) ->
            _.each bookmarks, (data) ->
                new Bookmark(data)

        subscribe 'loaded.model', renderBookmarks
        subscribe 'filtered.model', renderBookmarks
