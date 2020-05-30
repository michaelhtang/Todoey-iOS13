//
//  Category.swift
//  Todoey
//
//  Created by Michael Tang on 2020-05-27.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    let items = List<Item>()
     
}
