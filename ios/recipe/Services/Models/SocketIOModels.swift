//
//  SocketIOModels.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/05/02.
//

import SocketIO

public struct MessageModel: SocketData {
  var date: Date
  var senderID: Int
  var friendID: Int
  var text: String

  public func socketRepresentation() -> SocketData {
    return [
      "sender": senderID,
      "friend": friendID,
      "date": date.timeIntervalSince1970,
      "text": text
    ]
  }

  var shareRecipeDict: [String:Any]? {
    if let data = text.data(using: .utf8),
       let dict = try? JSONSerialization.jsonObject(
        with: data,
        options:.mutableContainers
       ) as? [String:Any],
       let recipeID = dict["recipeID"],
       let recipeName = dict["recipeName"],
       let recipeImageURLString = dict["recipeImageURL"] as? String,
       let recipeImageURL = URL(string: recipeImageURLString)
    {
      return [
        "recipeID": recipeID,
        "recipeName": recipeName,
        "recipeImageURL": recipeImageURL
      ]
    }
    return nil
  }
}

public struct SocketJoinRoomModel: SocketData {
  let sender: Int
  let friend: Int

  public func socketRepresentation() -> SocketData {
    return ["sender": sender, "friend": friend]
  }
}
