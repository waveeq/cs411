import flask, flask.views
from flask import Flask, render_template, Response
from sqlalchemy import create_engine, MetaData 
import settings
import json

class RecipeNote(flask.views.MethodView):
    def _put_recipe_note(self, user_id, recipe_id,note):
        if user_id == None or recipe_id == None or note == None:
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
        user_id = flask.request.args.get('user_id')
        recipe_id = flask.request.args.get('recipe_id')
        note = flask.request.args.get('note')

        return self._put_recipe_note(user_id, recipe_id, note)
