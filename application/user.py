import flask, flask.views
from flask import Flask, render_template, Response
from sqlalchemy import create_engine, MetaData 
import settings
import json
import hashlib
import hmac


class User(flask.views.MethodView):
    def _put_user(self, profile_image_param , user_name_param , email_param , first_name_param, last_name_param, password_param, birth_date_param, country_param):
        
        if email_param == None or user_name_param == None or password_param == None :
            return

        mysqlUN = settings.MYSQL_USER
        mysqlPW = settings.MYSQL_PASSWORD
        dbname = settings.MYSQL_DB
        dbhost = settings.MYSQL_HOST

        hashed_password = self.hash_password(password_param)
        
        myDatabase = 'mysql://%(UN)s:%(PW)s@%(host)s/%(name)s?charset=utf8&use_unicode=1' % \
        {'UN': mysqlUN, 'PW': mysqlPW, 'host': dbhost, 'name': dbname}
        engine = create_engine(myDatabase, pool_recycle=3600)  

        with engine.connect() as connection:
            result = connection.execute(
                """
                INSERT INTO USER  (profile_image, user_name, email, first_name, last_name, password, birth_date, country)
                VALUES ("%s","%s", "%s", "%s", "%s", "%s" , "%s" , "%s" )
                """,
                [profile_image_param , user_name_param , email_param , first_name_param, last_name_param, hashed_password, birth_date_param, country_param])
            return Response(status=200)

    def hash_password(self,password):
        return hashlib.sha256(password.encode('utf-8')).hexdigest()
        
    def put(self):
        
        profile_image_param = flask.request.args.get('profile_image')
        user_name_param  = flask.request.args.get('user_name')
        email_param  = flask.request.args.get('email')
        first_name_param = flask.request.args.get('first_name')
        last_name_param = flask.request.args.get('last_name')
        password_param = flask.request.args.get('password')
        birth_date_param = flask.request.args.get('birth_date')
        country_param = flask.request.args.get('country')                        

        return self._put_User(profile_image_param, user_name_param, email_param, first_name_param, last_name_param, password_param, birth_date_param, country_param)

    def _get_user(self,uid):
        mysqlUN = settings.MYSQL_USER
        mysqlPW = settings.MYSQL_PASSWORD
        dbname = settings.MYSQL_DB
        dbhost = settings.MYSQL_HOST

        myDatabase = 'mysql://%(UN)s:%(PW)s@%(host)s/%(name)s?charset=utf8&use_unicode=1' % \
                     {'UN': mysqlUN, 'PW': mysqlPW, 'host': dbhost, 'name': dbname}
        engine = create_engine(myDatabase, pool_recycle=3600)
        connection = engine.connect()
        with connection:
            result = connection.execute("select * from User u where uid=%s",[uid])
            list_result = [dict(row) for row in result]
        if not list_result:
            return flask.abort(404)
        else:
            return flask.jsonify(list_result)

    def get(self):
        uid = flask.request.args.get('user_id')
        if uid == None:
            return flask.abort(404)
        return self._get_user(uid)