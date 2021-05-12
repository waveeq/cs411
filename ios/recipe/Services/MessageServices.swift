//
//  MessageServices.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/05/11.
//

import Foundation

public class MessageServices {

  static let sharedInstance = MessageServices()
  static let endpoint = "http://44.192.111.170"
  static let socketIOPort = "5000"
  static let socketIONamespace = "/chat"

  static var socketIOEndpoint: String {
    return endpoint + ":" + socketIOPort
  }

  public func getRecentMessagesList(
    forUserID userID: Int,
    completion: @escaping ([MessageModel]) -> Void
  ) {
    RESTAPIHelper.requestGet(
      withUrl: URL(string: "\(Self.endpoint)/messages")!,
      params: ["user_id" : userID, "limit_one" : "yes"]
    ) { (result) in

      var messageModels: [MessageModel] = []

      if let messageModelDictList = result?["result"] as? [[String:Any]] {
        messageModelDictList.forEach { messageModelDict in
          if let dateEpoch = messageModelDict["date"] as? Double,
             let friend = messageModelDict["friend"] as? Int,
             let sender = messageModelDict["sender"] as? Int,
             let text = messageModelDict["text"] as? String {

            if sender != friend {
              messageModels.append(
                MessageModel(
                  date: Date(timeIntervalSince1970: dateEpoch),
                  senderID: sender,
                  friendID: friend,
                  text: text
                )
              )
            }
          }
        }
      }

      DispatchQueue.main.async {
        completion(messageModels)
      }
    }
  }

  public func getHistoricalMessagesList(
    forUserID userID: Int,
    friendID: Int,
    completion: @escaping ([MessageModel]) -> Void
  ) {
    RESTAPIHelper.requestGet(
      withUrl: URL(string: "\(Self.endpoint)/messages")!,
      params: ["user_id" : userID, "friend_id" : friendID]
    ) { (result) in
      var messageModels: [MessageModel] = []

      if let messageModelDictList = result?["result"] as? [[String:Any]] {
        messageModelDictList.forEach { messageModelDict in
          if let dateEpoch = messageModelDict["date"] as? Double,
             let friend = messageModelDict["friend"] as? Int,
             let sender = messageModelDict["sender"] as? Int,
             let text = messageModelDict["text"] as? String {

            messageModels.append(
              MessageModel(
                date: Date(timeIntervalSince1970: dateEpoch),
                senderID: sender,
                friendID: friend,
                text: text
              )
            )
          }
        }
      }

      DispatchQueue.main.async {
        completion(messageModels)
      }
    }
  }
}
