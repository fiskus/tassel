from flask import Flask, render_template, jsonify, request
import dataset

app = Flask(__name__)

db = dataset.connect('sqlite:///bookmarks.sqlite')
table = db['bookmarks']

@app.route('/')
def index():
    return render_template('bookmarks.html')

@app.route('/get/')
def get():
    bookmarks = []
    for row in table.all():
        url = row['url']
        title = row['title']
        tags = row['tags']
        bookmarkJson = getBookmarkJson(url, title, tags)
        bookmarks.append(bookmarkJson)
    return jsonify(dict(bookmarks = bookmarks))

#Rename to add
@app.route('/post/', methods=['POST'])
def post():
    url = request.form['url']
    title = request.form['title']
    tags = getTagsString(request.form.getlist('tags[]'))
    bookmark = dict(
        url = url,
        title = title,
        tags = tags
    )
    table.insert(bookmark)
    bookmarkJson = getBookmarkJson(url, title, tags)
    return jsonify(dict(bookmark = bookmarkJson))

@app.route('/edit/', methods=['POST'])
def edit():
    url = request.form['url']
    title = request.form['title']
    tags = getTagsString(request.form.getlist('tags[]'))
    bookmark = dict(
        url = url,
        title = title,
        tags = tags
    )
    response = table.update(bookmark, ['url'])
    bookmarkJson = getBookmarkJson(url, title, tags)
    return jsonify(dict(bookmark = bookmarkJson))

@app.route('/delete/', methods=['POST'])
def delete():
    url = request.form['url']
    table.delete(url = url)
    return jsonify(dict(status = 'success'))

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
    app.debug = True
    app.run()
