from flask import Flask, render_template, jsonify, request
import dataset

app = Flask(__name__)
app.jinja_env.add_extension('pyjade.ext.jinja.PyJadeExtension')

db = dataset.connect('sqlite:///tassel.sqlite')
table = db['tassel']


@app.route('/')
def index():
    return render_template('tassel.jade')


@app.route('/get/', methods=['GET'])
def get():
    bookmarks = []
    for row in table.all():
        bookmarkJson = getBookmarkJson(row['url'], row['title'], row['tags'])
        bookmarks.append(bookmarkJson)
    return jsonify(dict(bookmarks = bookmarks))


@app.route('/add/', methods=['POST'])
def add():
    bookmark = getBookmarkFromRequest(request)
    table.insert(bookmark)
    bookmarkJson = getBookmarkJson(bookmark['url'], bookmark['title'], bookmark['tags'])
    return jsonify(dict(bookmark = bookmarkJson))


@app.route('/edit/', methods=['POST'])
def edit():
    bookmark = getBookmarkFromRequest(request)
    response = table.update(bookmark, ['url'])
    bookmarkJson = getBookmarkJson(bookmark['url'], bookmark['title'], bookmark['tags'])
    return jsonify(dict(bookmark = bookmarkJson))


@app.route('/delete/', methods=['POST'])
def delete():
    url = request.form['url']
    table.delete(url = url)
    return jsonify(dict(status = 'success'))


def getBookmarkFromRequest(request):
    url = request.form['url']
    title = request.form['title']
    tags = getTagsString(request.form.getlist('tags[]'))
    bookmark = dict(
        url = url,
        title = title,
        tags = tags
    )
    return bookmark


def getBookmarkJson(url, title, tags):
    bookmarkJson = dict(
        url = url,
        title = title,
        tags = tags.split(' ')
    )
    return bookmarkJson


def getTagsString(rowTags):
    if rowTags[0].find(',') > 0:
        tags = rowTags[0].split(',')
    else:
        tags = rawTags
    return ' '.join(tags)


if __name__ == '__main__':
    app.run()
