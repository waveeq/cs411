import flask
from flask import Flask, Response
from sqlalchemy import create_engine
import settings

app = Flask(__name__)

mysqlUN = settings.MYSQL_USER
mysqlPW = settings.MYSQL_PASSWORD
dbname = settings.MYSQL_DB
dbhost = settings.MYSQL_HOST

myDatabase = 'mysql://%(UN)s:%(PW)s@%(host)s/%(nme)s?charset=utf8&use_unicode=1' % \
             {'UN': mysqlUN, 'PW': mysqlPW, 'host': dbhost, 'name': dbname}


@app.route('/recipe/<int:uid>/<int:recipeid>', methods=['DELETE'])
def delete_favorites(uid, recipeid):
    engine = create_engine(myDatabase, pool_recycle=3600)
    connection = engine.connect()
    with connection:
        result = connection.execute('select 1 from user_favorites_recipe fr where (uid = %s and recipeid = %s)',
                                    [uid, recipeid])
        data = [[str(row[0])] for row in result]
        if not data:
            return flask.abort(404)
        else:
            connection.execute('delete from user_favorites_recipe where (uid = %s and recipeid = %s)', [uid, recipeid])
            return Response(status=200)


@app.route('/recipe/<int:uid>/<int:recipeid>', methods=['POST'])
def insert_favorites(uid, recipeid):
    engine = create_engine(myDatabase, pool_recycle=3600)
    connection = engine.connect()
    with connection:
        result = connection.execute('select 1 from user_favorites_recipe fr where (uid = %s and recipeid = %s)',
                                    [uid, recipeid])
        data = [[str(row[0])] for row in result]
        if data:
            return flask.abort(404)
        else:
            connection.execute('insert into user_favorites_recipe values (%s, %s)', [uid, recipeid])
            return Response(status=200)


if __name__ == '__main__':
    app.run()
