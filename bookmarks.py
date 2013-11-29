from flask import Flask, render_template, jsonify

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

if __name__ == '__main__':
    app.debug = True
    app.run()
