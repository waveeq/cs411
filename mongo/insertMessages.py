from pymongo import MongoClient
import random
import numpy as np
from datetime import datetime

def generateMessage():
    message = {}
    messageContents = np.array(["hi","hello","bye","give me my money"])
    userIds = np.arange(4)
    userNames = np.array(["Alice","Bob","Charlie","Dikra"])
    user_a_id, user_b_id = np.random.choice(userIds, size=2,replace=False)
    message["user_id_from"], message["user_id_to"] = int(user_a_id), int(user_b_id)
    message["user_name_to"] = userNames[message["user_id_from"]]
    message["user_name_from"] = userNames[message["user_id_to"]]
    message["content"] = np.random.choice(messageContents, replace=True)
    message["creation_time"] = datetime.now()
    return message 


def insertMessage(db):
    message = generateMessage()
    collection = db.Messages
    collection.insert_one(message)

def insertMessages(db,N):
    messages = [generateMessage() for i in range(N) ]
    collection = db.Messages
    collection.insert_many(messages)

def clearAllMessages(db):
    db.Messages.delete_many({})


if __name__ == "__main__":
    client = MongoClient()
    db = client.cs411
    clearAllMessages(db)
    insertMessage(db)
