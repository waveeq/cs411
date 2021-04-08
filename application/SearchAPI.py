import flask
from flask import Flask, Response,jsonify
from sqlalchemy import create_engine
import settings
import json

app = Flask(__name__)

mysqlUN = settings.MYSQL_USER
mysqlPW = settings.MYSQL_PASSWORD
dbname = settings.MYSQL_DB
dbhost = settings.MYSQL_HOST

myDatabase = 'mysql://%(UN)s:%(PW)s@%(host)s/%(name)s?charset=utf8&use_unicode=1' % \
             {'UN': mysqlUN, 'PW': mysqlPW, 'host': dbhost, 'name': dbname}

@app.route('/explore/<int:uid>', methods=['GET'])
def search(uid):
    engine = create_engine(myDatabase, pool_recycle=3600)
    connection = engine.connect()
    with connection:
        result = connection.execute('select recipeid, title, main_image from recipe r limit 10')
        list_result = [dict(row) for row in result]
    if not list_result:
        return flask.abort(404)
    else:
        return flask.jsonify(list_result)


if __name__ == '__main__':
    app.run()
