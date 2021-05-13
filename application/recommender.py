import flask,flask.views
from sqlalchemy import create_engine
import settings
import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
import numpy as np
from cosineSimilarity import get_list_cos
from processText import process_text


mysqlUN = settings.MYSQL_USER
mysqlPW = settings.MYSQL_PASSWORD
dbname = settings.MYSQL_DB
dbhost = settings.MYSQL_HOST

myDatabase = 'mysql://%(UN)s:%(PW)s@%(host)s/%(name)s?charset=utf8&use_unicode=1' % \
             {'UN': mysqlUN, 'PW': mysqlPW, 'host': dbhost, 'name': dbname}

class Recommender(flask.views.MethodView):
    def _grab_recipes(self):
        engine = create_engine(myDatabase, pool_recycle=3600)
        connection = engine.connect()
        with connection:
            allrecipes = connection.execute('select recipeid,summary,ingredients,title,main_image from recipe where main_image is not null')
        allrecipes = [dict(row) for row in allrecipes]

        for recipe in allrecipes:
            recipe['text'] = recipe['title'] + recipe['summary'] + recipe['ingredients']
        allrecipesdf = pd.DataFrame(allrecipes)
        allrecipesdf['text'] = allrecipesdf['text'].apply(process_text)

        return allrecipesdf


    def _grab_user_preferences(self, user_id):
        engine = create_engine(myDatabase, pool_recycle=3600)
        connection = engine.connect()
        with connection:
            userpreferences = connection.execute('select fr.uid, r.recipeid, r.summary, r.ingredients,r.title from '
                                                 'User_Favorites_Recipe fr, recipe r where r.recipeid = fr.recipeid and fr.uid = %s',
                                                 [user_id])
        userpreferences = [dict(row) for row in userpreferences]
        for recipe in userpreferences:
            recipe['text'] = recipe['title'] + recipe['summary'] + recipe['ingredients']
        userpreferencedf = pd.DataFrame(userpreferences)
        print(userpreferencedf['text'])
        userpreferencedf['text'] = userpreferencedf['text'].apply(process_text)
        return userpreferencedf

    def get(self):
        user_id = flask.request.args.get('user_id')

        userpreferencedf = self._grab_user_preferences(user_id)
        allrecipesdf = self._grab_recipes()

        recipematrix,uservector = self._fit_transform(allrecipesdf, userpreferencedf)

        listcos = get_list_cos(recipematrix, uservector)

        recommendations = self._recommendations(listcos, allrecipesdf, userpreferencedf)
        return recommendations

    def _fit_transform(self, allrecipesdf, userpreferencedf):
        userpreferencedf = userpreferencedf.groupby('uid')['text'].apply(' '.join).reset_index()

        vectorizer = TfidfVectorizer(min_df=0.01, max_df=0.5)
        recipematrix = vectorizer.fit_transform(allrecipesdf['text'])
        uservector = vectorizer.transform(userpreferencedf['text'])

        recipematrix = np.array(recipematrix.toarray())
        uservector = np.array(uservector.toarray()[0])

        #print(vectorizer.get_feature_names())
        #print(len(vectorizer.get_feature_names()))
        #print(len(recipematrix))
        #print(len(recipematrix[0]))
        #print(len(uservector))
        #print(recipematrix[:10])
        return recipematrix,uservector



    def _recommendations(self,listcos,allrecipesdf, userpreferencedf):
        existingpreferences = userpreferencedf['recipeid'].to_numpy()
        for val in listcos[:21]:
            i = val['recipeindex']
            recipeid = int(allrecipesdf['recipeid'].iloc[i])
            if recipeid in existingpreferences:
                val['cosscore'] = 0
        recommendations = []
        listtop = sorted(listcos,key = lambda i: i['cosscore'],reverse=True)[:21]
        for val in listtop:
            i = val['recipeindex']
            recommendation = {'recipeid': int(allrecipesdf['recipeid'].iloc[i]),
                              'main_image': allrecipesdf['main_image'].iloc[i]}
                              #'score': val}
            recommendations.append(recommendation)


        return flask.jsonify(recommendations)
