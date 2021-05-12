import flask, flask.views
from flask import Flask, render_template, Response
import json
from pymongo import MongoClient


class Messages(flask.views.MethodView):
    def _user_filter_factory(self,_id):
        return lambda x : (("user_id_to" in x and x["user_id_to"] == _id) or ("user_id_from" in x and x["user_id_from"] == _id))

    def get(self):
        user_id = flask.request.args.get('user_id')
        friend_id = flask.request.args.get('friend_id')
        limit_one = flask.request.args.get('limit_one')

        if user_id == None:
            return flask.abort(404)
        
        try:
            user_id = int(user_id)
        except ValueError:
            return flask.abort(400)

        client = MongoClient()
        db = client.cs411
        db_messages = db.Messages.find().sort("creation_time",-1)
        db_messages = list(filter(self._user_filter_factory(user_id), db_messages))

        if friend_id != None:
            try:
                friend_id = int(friend_id)
            except ValueError:
                return flask.abort(400)
            db_messages = list(filter(self._user_filter_factory(friend_id), db_messages))

        if limit_one != None:
            most_recent_message_by_user = dict()

            for message in db_messages:
                _id = -1
                if user_id == message["user_id_to"]:
                    _id = message["user_id_from"]
                else:
                    _id = message["user_id_to"]
                if _id not in most_recent_message_by_user:
                    most_recent_message_by_user[_id] = message

            db_messages = list(most_recent_message_by_user.values())
        messages = []
        for db_message in db_messages:
            message = {}
            message["sender"] = db_message.get("user_id_from")
            message["friend"] = db_message.get("user_id_to")
            message["date"] = db_message.get("creation_time").timestamp()
            message["text"] = db_message.get("content","")
            messages.append(message)
        return flask.jsonify(messages)

        