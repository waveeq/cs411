//
//  SocketIOModels.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/05/02.
//

import SocketIO

public struct MessageBubbleModel: SocketData {
  let sender: Int
  let friend: Int
  var isText: Bool
  var date: Date
  var text: String?
  var recipeID: Int?

  public func socketRepresentation() -> SocketData {
    var dict: [String : Any] = [
      "sender": sender,
      "friend": friend,
      "isText": isText,
      "date": date.timeIntervalSince1970
    ]

    if let text = text {
      dict["text"] = text
    }

    if let recipeID = recipeID {
      dict["recipeID"] = recipeID
    }

    return dict
  }
}

public struct SocketJoinRoomModel: SocketData {
  let sender: Int
  let friend: Int

  public func socketRepresentation() -> SocketData {
    return ["sender": sender, "friend": friend]
  }
}
