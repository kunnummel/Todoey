//
//  Data.swift
//  Todoey
//
//  Created by Mac Dev on 10/04/2018.
//  Copyright © 2018 Mac Dev. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var age : Int = 0
    
}