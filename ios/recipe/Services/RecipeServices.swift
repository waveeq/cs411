//
//  RecipeServices.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/04/04.
//

import Foundation
import UIKit

extension Notification.Name {
    static let myRecipesDataModified = Notification.Name("myRecipesDataModified")
}

public class RecipeServices {

  static let sharedInstance = RecipeServices()
  static let endpoint = "http://44.192.111.170"

  var recipeImageCache: [Int:UIImage] = [:]

  public func getRecipeDetails(
    forUserID userID: Int,
    recipeID: Int,
    completion: @escaping (RecipeDetailModel?) -> Void
  ) {
    RESTAPIHelper.requestGet(
      withUrl: URL(string: "\(Self.endpoint)/recipe/details")!,
      params: ["user_id" : userID, "recipe_id": recipeID]
    ) { (result) in

      var recipeDetailModel: RecipeDetailModel? = nil

      if let recipeDetailsDict = result?["result"] as? [String:Any],
         let title = recipeDetailsDict["title"] as? String,
         let mainImageString = recipeDetailsDict["main_image"] as? String,
         let isFavoritedSign = recipeDetailsDict["isFavorited"] as? Int {

        let summary = recipeDetailsDict["summary"] as? String

        // Handle the 'quote' character bug.
        var userNote = recipeDetailsDict["user_note"] as? String
        if let tempUserNote = userNote, tempUserNote.hasPrefix("'") {
          userNote?.removeFirst()
        }
        if let tempUserNote = userNote, tempUserNote.hasSuffix("'") {
          userNote?.removeLast()
        }

        recipeDetailModel = RecipeDetailModel(
          recipeID: recipeID,
          title: title,
          mainImage: URL(string: mainImageString)!,
          isFavorited: isFavoritedSign == 1,
          cookingTime: recipeDetailsDict["cookingTime"] as? Int,
          directions: recipeDetailsDict["directions"] as? String,
          ingredients: recipeDetailsDict["ingredients"] as? String,
          nutritionalCalories: recipeDetailsDict["nutritional_calories"] as? Double,
          summary: summary,
          userNote: userNote
        )
      }

      DispatchQueue.main.async {
        completion(recipeDetailModel)
      }
    }
  }

  public func getExploreList(
    forUserID userID: Int,
    query: String?,
    completion: @escaping ([ExploreModel]?) -> Void
  ) {
    let isZeroState = query == nil || query?.count == 0
    let urlString = isZeroState ? "\(Self.endpoint)/explore/0" : "\(Self.endpoint)/explore"
    let params: [String:Any] = isZeroState ? ["user_id":userID] : ["title":query!]


    RESTAPIHelper.requestGet(
      withUrl: URL(string: urlString)!,
      params: params
    ) { (result) in

      var exploreModels: [ExploreModel] = []

      if let exploreModelDictList = result?["result"] as? [[String:Any]] {
        exploreModelDictList.forEach { exploreModelDict in
          if let recipeID = exploreModelDict["recipeid"] as? Int,
             let mainImageUrlString = exploreModelDict["main_image"] as? String {
            exploreModels.append(ExploreModel(
              recipeID: recipeID,
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

  public func getMyRecipeList(
    forUserID userID: Int,
    completion: @escaping ([MyRecipeModel]?) -> Void
  ) {
    RESTAPIHelper.requestGet(
      withUrl: URL(string: "\(Self.endpoint)/favorites")!,
      params: ["user_id" : userID]
    ) { (result) in
      var myRecipeModels: [MyRecipeModel] = []

      if let myRecipeModelDictList = result?["result"] as? [[String]] {
        myRecipeModelDictList.forEach { myRecipeModelDict in
          if let recipeID = Int(myRecipeModelDict[0]) {
            let mainImageUrlString = myRecipeModelDict[1]

            myRecipeModels.append(MyRecipeModel(
              recipeID: recipeID,
              mainImage: URL(string: mainImageUrlString)!
            ))
          }
        }
      }

      DispatchQueue.main.async {
        completion(myRecipeModels)
      }
    }
  }

  public func insertRecipeToMyRecipeList(
    forUserID userID: Int,
    recipeID: Int,
    completion: @escaping (Bool) -> Void
  ) {
    RESTAPIHelper.requestPost(
      withUrl: URL(string: "\(Self.endpoint)/recipe")!,
      params: ["user_id" : userID, "recipe_id": recipeID]) { (result) in
      let success: Bool = result?["success"] as? Bool ?? false

      DispatchQueue.main.async {
        if success {
          NotificationCenter.default.post(name: .myRecipesDataModified, object: nil)
        }
        completion(success)
      }
    }
  }

  public func removeRecipeFromMyRecipeList(
    forUserID userID: Int,
    recipeID: Int,
    completion: @escaping (Bool) -> Void
  ) {
    RESTAPIHelper.requestDelete(
      withUrl: URL(string: "\(Self.endpoint)/recipe")!,
      params: ["user_id" : userID, "recipe_id": recipeID]) { (result) in
      let success: Bool = result?["success"] as? Bool ?? false

      DispatchQueue.main.async {
        if success {
          NotificationCenter.default.post(name: .myRecipesDataModified, object: nil)
        }
        completion(success)
      }
    }
  }

  public func updateRecipeNotes(
    forUserID userID: Int,
    recipeID: Int,
    notes: String,
    completion: @escaping (Bool) -> Void
  ) {
    RESTAPIHelper.requestPut(
      withUrl: URL(string: "\(Self.endpoint)/recipe/note")!,
      params: ["user_id" : userID, "recipe_id": recipeID, "note": notes]) { (result) in
      DispatchQueue.main.async {
        let success: Bool = result?["success"] as? Bool ?? false

        completion(success)
      }
    }
  }

  public func loadImage(
    forRecipeID recipeID: Int,
    url: URL,
    completion: @escaping (UIImage?) -> Void
  ) {
    if let image = recipeImageCache[recipeID] {
      completion(image)
      return
    }

    DispatchQueue.global().async {
      let image = try? UIImage(data: Data(contentsOf: url))

      DispatchQueue.main.async {
        self.recipeImageCache[recipeID] = image
        completion(image)
      }
    }
  }
}
