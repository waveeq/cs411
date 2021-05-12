import flask
from flask import Flask, Response,jsonify
from sqlalchemy import create_engine
import settings


class ExploreRecipes(flask.views.MethodView):
    def _explore_API(self,title):
        s = "%"+title+"%"
        mysqlUN = settings.MYSQL_USER
        mysqlPW = settings.MYSQL_PASSWORD
        dbname = settings.MYSQL_DB
        dbhost = settings.MYSQL_HOST

        myDatabase = 'mysql://%(UN)s:%(PW)s@%(host)s/%(name)s?charset=utf8&use_unicode=1' % \
                     {'UN': mysqlUN, 'PW': mysqlPW, 'host': dbhost, 'name': dbname}
        engine = create_engine(myDatabase, pool_recycle=3600)
        connection = engine.connect()
        with connection:
            resultwithratings = connection.execute("select r.recipeid, title, main_image, value from Recipe r, User_Rates_Recipe ur where title like %s and r.recipeid=ur.recipeid order by recipeid",[s])
            resultnoratings = connection.execute("select recipeid, title, main_image from Recipe where title like %s and recipeid not in (select recipeid from User_Rates_Recipe)",[s])
            listresult = [dict(row) for row in resultwithratings]
            listnoratings = [dict(row) for row in resultnoratings]

        if not (listresult or listnoratings):
            return flask.abort(404)

        for i in listnoratings:
            i['mean'] = 0

        sortedrecipes = []
        for i in listresult:
            if i['recipeid'] not in [r['recipeid'] for r in sortedrecipes]:
                recipe = {}
                recipe['recipeid'] = i['recipeid']
                recipe['value'] = [i['value']]
                recipe['main_image'] = i['main_image']
                sortedrecipes.append(recipe)
            else:
                recipe['value'].append(i['value'])
        for i in sortedrecipes:
            i['mean'] = sum(i['value'])/len(i['value'])
            del i['value']

        sortedrecipes = sortedrecipes + listnoratings

        sortedrecipes = sorted(sortedrecipes, key = lambda x: (x['main_image'] is not None,x['mean']), reverse=True)
        sortedrecipes = sortedrecipes[:90]
        #print(len(sortedrecipes))
        return flask.jsonify(sortedrecipes)

    def get(self):
        title= flask.request.args.get('title')
        if title == None:
            return flask.abort(404)
        return self._explore_API(title)

