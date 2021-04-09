import flask, flask.views
from flask import Flask, render_template, Response
from sqlalchemy import create_engine, MetaData
import settings
import json


class FavoritesDelete(flask.views.MethodView):
    def _favorites_delete(self,user_id,recipe_id):
        mysqlUN = settings.MYSQL_USER
        mysqlPW = settings.MYSQL_PASSWORD
        dbname = settings.MYSQL_DB
        dbhost = settings.MYSQL_HOST

        myDatabase = 'mysql://%(UN)s:%(PW)s@%(host)s/%(name)s?charset=utf8&use_unicode=1' % \
                     {'UN': mysqlUN, 'PW': mysqlPW, 'host': dbhost, 'name': dbname}
        engine = create_engine(myDatabase, pool_recycle=3600)
        connection = engine.connect()
        with connection:
            result = connection.execute('select 1 from user_favorites_recipe fr where (uid = %s and recipeid = %s)',
                                        [user_id, recipe_id])
            data = [[str(row[0])] for row in result]
            if not data:
                return flask.abort(404)
            else:
                connection.execute('delete from user_favorites_recipe where (uid = %s and recipeid = %s)', [user_id, recipe_id])
                return Response(status=200)

    def delete(self):
        user_id = flask.request.args.get('user_id')
        recipe_id = flask.request.args.get('recipe_id')
        return self._favorites_delete(user_id,recipe_id)