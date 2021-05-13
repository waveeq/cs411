//
//  AccountManager.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/04/09.
//

import Foundation

public class AccountManager {

  static let sharedInstance = AccountManager()

  public var currentUserID: Int = -1
  public var currentUserModel: UserModel? = nil

  public func login(
    withUsername username: String,
    password: String,
    completion: @escaping (UserModel?) -> Void) {

    UserServices.sharedInstance.getUserID(forUsername: username, password: password) { userID in
      guard let userID = userID else {
        DispatchQueue.main.async { completion(nil) }
        return
      }

      UserServices.sharedInstance.getUserProfile(forUserID: userID) { userModel in
        self.currentUserID = userID
        self.currentUserModel = userModel

        DispatchQueue.main.async {
          completion(userModel)
        }
      }
    }
  }
}
