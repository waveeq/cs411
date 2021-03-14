
import flask, flask.views
from flask import request, render_template
import os
import json
import logging
from logging.handlers import RotatingFileHandler
from sqlalchemy import create_engine, MetaData 
import settings
from main import Main

app = flask.Flask(__name__)

# Don't do this!
#app.secret_key = "zeqbkx"

class Root(flask.views.MethodView):
    def get(self):
        print("here")
        mysqlUN = settings.MYSQL_USER
        mysqlPW = settings.MYSQL_PASSWORD
        dbname = settings.MYSQL_DB
        dbhost = settings.MYSQL_HOST

        myDatabase = 'mysql://%(UN)s:%(PW)s@%(host)s/%(name)s?charset=utf8&use_unicode=0' % \
        {'UN': mysqlUN, 'PW': mysqlPW, 'host': dbhost, 'name': dbname} 
        query = "SELECT user_name FROM User"
        engine = create_engine(myDatabase, pool_recycle=3600) 
        connection = engine.connect()
        tabledata = engine.execute(query)
        newtabledata = []
        for row in tabledata:
            newtabledata.append(row[0])
        connection.close()
        return flask.render_template('index.html', tabledata=newtabledata)

app.add_url_rule('/', view_func=Root.as_view('root'))
app.add_url_rule('/<page>/', view_func=Main.as_view('page'), methods=["GET"])

if __name__ == '__main__':
    formatter = logging.Formatter("[%(asctime)s] {%(pathname)s:%(lineno)d} %(levelname)s - %(message)s")
    handler = RotatingFileHandler('app.log', maxBytes=10000000, backupCount=5)
    handler.setLevel(logging.DEBUG)
    handler.setFormatter(formatter)
    app.logger.addHandler(handler)
    app.run(host="0.0.0.0", port=8080)