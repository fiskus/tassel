# Simple and easy to use bookmarks server

## Installation

### Frontend

* Install node dependencies

    `$ npm install`

* Install browserify

    `# npm install -g browserify`

* Build javascript libraries

    `$ browserify setup.js > static/lib/bundle.js`

* Compile static

    `$ grunt`

### Backend

* Create virtual environment

    `$ virtualenv2 .`

* Activate virtual environment

    `$ source bin/activate`

* Install python requirements

    `$ pip2 install -r requirements.txt`

### Done

* Start server

    `$ python2 tassel.py`

* Open browser at http://localhost:5000/

* Open docs at `docs/index.html`
