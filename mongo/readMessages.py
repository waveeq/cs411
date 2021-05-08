from pymongo import MongoClient

def get_messages(user_id):
    client = MongoClient()
    db = client.cs411
    return [x for x in db.Messages.find() if ((x.get("user_id_to") and x["user_id_to"] == user_id) or (x.get("user_id_from") and x["user_id_from"] == user_id))]

if __name__ == "__main__":
    print(get_messages(0))