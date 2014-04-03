# Tassel app
# @author Maxim Chervonny <fiskus@chervonny.ru>
class Tassel
    constructor: () ->
        # Initiate Form, Searchbar and TasselModel classes
        new Form()
        new Searchbar
        new TasselModel()

        subscribe 'loaded.model', _.bind(@renderBookmarks, @)
        subscribe 'filtered.model', _.bind(@renderBookmarks, @)


    # @param bookmarks [Array]
    renderBookmarks: (bookmarks) ->
        _.each bookmarks, (data) ->
            new Bookmark(data)
