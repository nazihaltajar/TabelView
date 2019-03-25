//
//  Restaurant.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 25/03/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import Foundation

class Restaurant {
        var name: String
        var type: String
        var location: String
        var image: String
        var isVisited: Bool

    init(name: String, type: String, location: String, image: String, isVisited: Bool) {
        self.name = name
        self.type = type
        self.location = location
        self.image = image
        self.isVisited = isVisited
    }

    convenience init() {
        self.init(name: "", type: "", location: "", image: "", isVisited: false)

    }
}
