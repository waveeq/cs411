import flask, flask.views
from flask import Flask, render_template, Response
from sqlalchemy import create_engine, MetaData 
import settings
import json

class User(flask.views.MethodView):
    def _put_user(self, profile_image_param , user_name_param , email_param , first_name_param, last_name_param, password_param, birth_date_param, country_param):
        
        if email_param == None or user_name_param == None or password_param == None :
            return

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
                INSERT INTO User_Notes_Recipe  (note, uid, recipeid)
                VALUES ("%s",%s,%s)
                ON DUPLICATE KEY UPDATE note=VALUES(note), recipeid=VALUES(recipeid)
                """,
                [note, user_id, recipe_id])
            return Response(status=200)

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
