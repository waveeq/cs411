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
    completion: @escaping ([ExploreModel]?) -> Void
  ) {

    RESTAPIHelper.requestGet(
      withUrl: URL(string: "\(Self.endpoint)/explore")!,
      params: nil
    ) { (result) in

      var exploreModels: [ExploreModel] = []

      if let exploreModelDictList = result?["result"] as? [[String:Any]] {
        exploreModelDictList.forEach { exploreModelDict in
          if let recipeID = exploreModelDict["recipeid"] as? Int,
             let title = exploreModelDict["title"] as? String,
             let mainImageUrlString = exploreModelDict["main_image"] as? String {
            exploreModels.append(ExploreModel(
              recipeID: recipeID,
              title: title,
              mainImage: URL(string: mainImageUrlString)!
            ))
          }
        }
      }

      DispatchQueue.main.async {
        completion(exploreModels)
      }
    }
  }
}
