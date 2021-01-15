//
//  User.swift
//  ExtendTodo
//
//  Created by Nhan Huynh on 1/15/21.
//

import Foundation


import KeychainSwift

fileprivate let keychain = KeychainSwift()

struct User {
    static func isLogged() -> Bool {
        keychain.accessGroup = Constants.group
        if let _ = keychain.get(Constants.keyService) {
            return true
        } else {
            return false
        }
    }
}
