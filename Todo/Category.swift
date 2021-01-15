//
//  Category.swift
//  Todo
//
//  Created by Nhan Huynh on 1/12/21.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var dateCreated: Date = Date()
    @objc dynamic var color: String = ""
    let items = List<Item>()
}
