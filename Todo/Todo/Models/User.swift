//
//  User.swift
//  Todo
//
//  Created by Nhan Huynh on 1/15/21.
//

import Foundation
import KeychainSwift
import RealmSwift

fileprivate let keychain = KeychainSwift()

let realm = try! Realm()

class User: Object {
    
    @objc dynamic var username: String = ""
    @objc dynamic var password: String = ""
    
    /* Logging to system.
     - Print: "Wrong username or password" if username/password to login wrong
    */
    func login() {
        keychain.accessGroup = Constants.group
        if (username.count != 0 && password.count != 0) {
            let realm = try! Realm()
            if let user = realm.objects(User.self).filter("username = %@ AND password = %@", username, password).first {
                let dataStore = "\(user.username)@\(user.password)"
                saveKeyChain(dataStore: dataStore, withKey: Constants.keyService)
            } else {
                print("Wrong username or password")
            }
        }
        
    }
    
    /* Checking logged or not yet
     - Use the keychain to checking logging
     - Return: true if logged or false if log in yet
    */
    static func isLogged() -> Bool {
        if let _ = keychain.get(Constants.keyService) {
            return true
        } else {
            return false
        }
    }
    
    /* Save a keychain to keychain store
     - Parameter dataStore<String>: Data will be saving on local keychain
     - Parameter withKey<String>: Key will be use to saving and get data from keychain
     */
    private func saveKeyChain(dataStore: String, withKey: String) {
        if keychain.set(dataStore, forKey: withKey, withAccess: .accessibleWhenUnlocked) {
            print("Saving succeed")
        } else {
            print("Can't saving keychain")
        }
    }
    
    /* Reset a keychain from keychain store
     - Parameter withKey<String>: Key will be use to reset data from keychain
     */
    private static func resetKeyChain(withKey: String) {
        keychain.delete(withKey)
    }
    
    /* Get a keychain from keychain store
     - Parameter withKey<String>: Key will be use to get data from keychain
     - Return: String of keychain or nil
     */
    private static func getKeyChain(withKey: String) -> String {
        return keychain.get(withKey)!
    }
    
    static func logout() {
        resetKeyChain(withKey: Constants.keyService)
    }
    
    /* Seed a default user */
    static func seedDefaultUser() {
        let realm = try! Realm()
        if (realm.objects(User.self).count == 0) {
            print("We will start seed a default user with \(Constants.dUsername)/\(Constants.dPassword)")
            let newUser = User()
            newUser.username = Constants.dUsername
            newUser.password = Constants.dPassword
            try! realm.write {
                realm.add(newUser)
            }
        }
    }
}
