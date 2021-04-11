//
//  AccountManager.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/04/09.
//

import Foundation

/// TODO(Dikra): Update to not use dummy user ID when login APIs are ready.
public class AccountManager {

  static let sharedInstance = AccountManager()
  static let dummyUserId: Int = 1

  public var currentUserID: Int {
    return Self.dummyUserId
  }
}
