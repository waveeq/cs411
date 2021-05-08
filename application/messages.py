import flask, flask.views
from flask import Flask, render_template, Response
import json
from pymongo import MongoClient


class Messages(flask.views.MethodView):
    def get(self):
        user_id = flask.request.args.get('user_id')
        if user_id == None:
            return flask.abort(404)
        
        try:
            user_id = int(user_id)
        except ValueError:
            return flask.abort(404)

        client = MongoClient()
        db = client.cs411
        db_messages = [x for x in db.Messages.find() if (("user_id_to" in x and x["user_id_to"] == user_id) or ("user_id_from" in x and x["user_id_from"] == user_id))]
        messages = []
        for db_message in db_messages:
            message = {}
            message["sender"] = db_message.get("user_id_from")
            message["friend"] = db_message.get("user_id_to")
            message["date"] = db_message.get("creation_time").timestamp()
            message["text"] = db_message.get("content","")
            messages.append(message)
        return flask.jsonify(messages)

        