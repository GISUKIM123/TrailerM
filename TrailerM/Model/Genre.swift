//
//  Genre.swift
//  TrailerM
//
//  Created by gisu kim on 2018-05-07.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

class Genre: NSObject {
    var id  : Int?
    var name : String?
    
    init(dictionary: [String : Any]) {
        id = dictionary["id"] as? Int
        name = dictionary["name"] as? String
    }
}
