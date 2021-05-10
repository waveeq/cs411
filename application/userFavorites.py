import flask, flask.views
from flask import Flask, render_template
from sqlalchemy import create_engine, MetaData 
import settings
import json

class UserFavorites(flask.views.MethodView):
    def _retrieve_user_favorites(self, user_id, first_idx, last_idx):
        if user_id == None:
            return
        user_id = str(int(user_id))

        mysqlUN = settings.MYSQL_USER
        mysqlPW = settings.MYSQL_PASSWORD
        dbname = settings.MYSQL_DB
        dbhost = settings.MYSQL_HOST

        myDatabase = 'mysql://%(UN)s:%(PW)s@%(host)s/%(name)s?charset=utf8&use_unicode=1' % \
        {'UN': mysqlUN, 'PW': mysqlPW, 'host': dbhost, 'name': dbname}
        engine = create_engine(myDatabase, pool_recycle=3600)  

        with engine.connect() as connection:
            result = []
            if first_idx != None and last_idx != None:
                last_idx = int(last_idx)
                first_idx = int(first_idx)
                result = connection.execute("SELECT recipeid, main_image FROM UserFavoriteView WHERE uid = %s  ORDER BY recipeid desc LIMIT %s OFFSET %s", [user_id, last_idx - first_idx, first_idx])
            elif first_idx != None and last_idx == None:
                first_idx = int(first_idx)
                result = connection.execute("SELECT recipeid, main_image FROM UserFavoriteView WHERE uid = %s  ORDER BY recipeid desc LIMIT 18446744073709551610 OFFSET %s", [user_id, first_idx])
            elif first_idx == None and last_idx != None:
                last_idx = int(last_idx)
                result = connection.execute("SELECT recipeid, main_image FROM UserFavoriteView WHERE uid = %s  ORDER BY recipeid desc LIMIT %s", [user_id, last_idx])
            else:
                result = connection.execute("SELECT recipeid, main_image FROM UserFavoriteView WHERE uid = %s  ORDER BY recipeid desc", [user_id])
            data = [[str(row[0]) ,str(row[1])] for row in result]
            return data

    def get(self):
        first_idx = flask.request.args.get('idx_start')
        last_idx = flask.request.args.get('idx_end')
        user_id = flask.request.args.get('user_id')

        favorites = self._retrieve_user_favorites(user_id, first_idx, last_idx)
        if favorites == None:
            return flask.abort(404)
    
        return flask.jsonify(favorites)
