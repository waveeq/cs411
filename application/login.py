import flask, flask.views
from flask import Flask, render_template, Response
from sqlalchemy import create_engine, MetaData
import settings
import json
import hashlib
import hmac


class Login(flask.views.MethodView):
    def _get_user_id(self, username, hashed_password):
        mysqlUN = settings.MYSQL_USER
        mysqlPW = settings.MYSQL_PASSWORD
        dbname = settings.MYSQL_DB
        dbhost = settings.MYSQL_HOST

        myDatabase = 'mysql://%(UN)s:%(PW)s@%(host)s/%(name)s?charset=utf8&use_unicode=1' % \
        {'UN': mysqlUN, 'PW': mysqlPW, 'host': dbhost, 'name': dbname}
        engine = create_engine(myDatabase, pool_recycle=3600)  

        with engine.connect() as connection:
            result = connection.execute(
                """
                SELECT uid
                FROM User
                WHERE user_name = %s and password = %s;
                """,
                [username, hashed_password])

        data = [dict(row) for row in result]

        if len(data) == 1:
            return data[0]
        else:
            return

    def hash_password(self,password):
        return hashlib.sha256(password.encode('utf-8')).hexdigest()

    def get(self):
        username = flask.request.args.get('username')
        password = flask.request.args.get('password')

        if username == None or password == None:
            return flask.abort(404)

        hashed_password = self.hash_password(password)
        user_id = self._get_user_id(username, hashed_password)
        if user_id == None:
            return Response(status=401)
        else:
            return flask.jsonify(user_id)