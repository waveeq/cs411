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
}

public struct SocketJoinRoomModel: SocketData {
  let sender: Int
  let friend: Int

  public func socketRepresentation() -> SocketData {
    return ["sender": sender, "friend": friend]
  }
}
