import flask, flask.views
from flask import Flask, render_template
from sqlalchemy import create_engine, MetaData 
import settings
import json

class RecipeDetails(flask.views.MethodView):
    def _retrieve_recipe_details(self, user_id, recipe_id):
        if user_id == None or recipe_id == None:
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
                SELECT 
                CASE WHEN EXISTS 
                (SELECT * fROM User_Favorites_Recipe favorites
                WHERE favorites.uid = t.uid
                AND favorites.recipeid = t.recipeid) THEN 1
                ELSE 0
                END as isFavorited,
                note.note as user_note,
                t.title as title , t.cookingTime as cookingTime, t.recipe_text as recipe_text, t.summary as summary,
                t.ingredients as ingredients, t.directions as directions, t.main_image as main_image, t.nutritional_calories as nutritional_calories,
                rating.value as user_rating
                FROM
                (SELECT
                *
                FROM 
                Recipe r,
                User u
                WHERE
                u.uid = %s
                AND r.recipeid = %s
                ) t
                LEFT JOIN User_Notes_Recipe note ON note.uid = t.uid AND note.recipeid = t.recipeid
                LEFT JOIN User_Rates_Recipe rating ON rating.uid = t.uid AND rating.recipeid = t.recipeid;
                """,
                [user_id, recipe_id])
            data = [dict(row) for row in result]
            if len(data) == 1:
                return data[0]
            else:
                return

    def get(self):
        user_id = flask.request.args.get('user_id')
        recipe_id = flask.request.args.get('recipe_id')

        details = self._retrieve_recipe_details(user_id, recipe_id)
        if details == None:
            return flask.abort(404)
    
        return flask.jsonify(details)
