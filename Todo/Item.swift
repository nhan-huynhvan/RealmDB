//
//  Item.swift
//  Todo
//
//  Created by Nhan Huynh on 1/12/21.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date = Date()
    @objc dynamic var color: String = ""
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
