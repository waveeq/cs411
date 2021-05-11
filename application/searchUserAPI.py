import flask
from flask import Flask, Response,jsonify
from sqlalchemy import create_engine
import settings
import json




class SearchUserAPI(flask.views.MethodView):
    def _search_user_API(self,partial_user_name):
        s = "%" + partial_user_name + "%"
        mysqlUN = settings.MYSQL_USER
        mysqlPW = settings.MYSQL_PASSWORD
        dbname = settings.MYSQL_DB
        dbhost = settings.MYSQL_HOST

        myDatabase = 'mysql://%(UN)s:%(PW)s@%(host)s/%(name)s?charset=utf8&use_unicode=1' % \
                     {'UN': mysqlUN, 'PW': mysqlPW, 'host': dbhost, 'name': dbname}
        engine = create_engine(myDatabase, pool_recycle=3600)
        connection = engine.connect()
        with connection:
            result = connection.execute("select uid, user_name from User u where user_name like %s",[s])
            list_result = [dict(row) for row in result]
        if not list_result:
            return flask.abort(404)
        else:
            return flask.jsonify(list_result)

    def get(self):
        partial_user_name = flask.request.args.get('partial_user_name')
        if partial_user_name == None:
            return flask.abort(404)
        return self._search_user_API(partial_user_name)

