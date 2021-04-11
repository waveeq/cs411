//
//  RecipeModel.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/04/04.
//

import Foundation
import UIKit

public struct RecipeDetailModel {
  var recipeID: Int
  var title: String
  var mainImage: URL
  var isFavorited: Bool
  var cookingTime: TimeInterval?
  var directions: String?
  var ingredients: String?
  var nutritionalCalories: Int?
  var recipeText: String?
  var summary: String?
  var userNote: String?
  var userRating: Int?
}

public struct ExploreModel {
  var recipeID: Int
  var title: String
  var mainImage: URL
}

public struct MyRecipeModel {
  var recipeID: Int
  var mainImage: URL
}
