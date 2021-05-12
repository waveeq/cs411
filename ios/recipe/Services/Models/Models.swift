//
//  Models.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/04/04.
//

import Foundation

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

public struct OldFriendModel {
  var userID: Int
  var name: String
  var profilePicture: URL?
}

public struct OldMessageModel {
  var date: Date
  var isText: Bool
  var text: String?
  var recipeID: Int?
  var mainImage: URL?
  var summary: String?
}

public struct OldRecentMessageModel {
  var friend: OldFriendModel
  var message: OldMessageModel?
}

public struct UserModel {
  var userID: Int
  var username: String
  var firstName: String
  var lastName: String
  var email: String
  var country: String
  var birthdate: Date
  var profileImage: URL?

  var birthdateString: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.string(from: birthdate)
  }

  var fullName: String {
    return firstName.capitalizingFirstLetter() + " " + lastName.capitalizingFirstLetter()
  }

  var fullNameAndUsername: String {
    return fullName + " (" + username + ")"
  }
}

public struct SearchUsernameModel {
  var userID: Int
  var username: String
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
