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

  let imageCache: [Int:UIImage] = [:]

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

      if let recipeDetailsDict = result?["result"] as? [String:Any] {
        recipeDetailModel = RecipeDetailModel(
          recipeID: recipeID,
          title: recipeDetailsDict["title"] as! String,
          mainImage: URL(string: recipeDetailsDict["main_image"] as! String)!,
          isFavorited: (recipeDetailsDict["isFavorited"] as! Int) == 1,
          cookingTime: nil,
          directions: nil,
          ingredients: nil,
          nutritionalCalories: nil,
          recipeText: nil,
          summary: recipeDetailsDict["summary"] as? String,
          userNote: recipeDetailsDict["user_note"] as? String,
          userRating: nil
        )
      }

      DispatchQueue.main.async {
        completion(recipeDetailModel)
      }
    }
  }

  public func getExploreList(
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

  public func loadImageData(
    forRecipeID recipeID: Int,
    url: URL,
    completion: @escaping (UIImage?) -> Void
  ) {
    var imageCache = Self.sharedInstance.imageCache

    if let image = imageCache[recipeID] {
      completion(image)
      return
    }

    DispatchQueue.global().async {
      let image = try? UIImage(data: Data(contentsOf: url))

      DispatchQueue.main.async {
        imageCache[recipeID] = image
        completion(image)
      }
    }
  }
}
