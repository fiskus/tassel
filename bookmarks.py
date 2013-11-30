from flask import Flask, render_template, jsonify, request

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('bookmarks.html')

@app.route('/get/')
def get():
    file = open('bookmarks.db', 'r')
    bookmarks = []
    for line in file:
        bookmarkArray = line.strip().split('|')
        bookmark = dict(
            url = bookmarkArray[0],
            title = bookmarkArray[1],
            tags = bookmarkArray[2].split(' ')
        )
        bookmarks.append(bookmark)
    return jsonify(dict(bookmarks=bookmarks))

@app.route('/post/', methods=['POST'])
def post():
    cache = getBookmarks()
    file = open('bookmarks.db', 'w')
    url = request.form['url']
    title = request.form['title']
    tags = ' '.join(request.form.getlist('tags[]'))
    bookmark = '|'.join([url, title, tags])
    content = cache + bookmark + '\n'
    file.write(content)
    file.close()
    return jsonify(dict(bookmark=bookmark))

def getBookmarks():
    file = open('bookmarks.db', 'r')
    cache = file.read()
    file.close()
    return cache

if __name__ == '__main__':
    app.debug = True
    app.run()







new_content = content + bookmark
file.write(new_content)
