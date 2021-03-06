//
//  Restaurant.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 25/03/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import Foundation

class RestaurantMO {
        var name: String
        var type: String
        var location: String
        var image: String
        var phone: String
        var description: String
        var isVisited: Bool
        var cellType: CellIdentifier = CellIdentifier.restaurantCellIdentifier
        var rating: String

    init(name: String = "", type: String = "", location: String = "", image: String = "",
         phone: String = "", description: String = "", isVisited: Bool = false, rating: String = " ") {
        self.name = name
        self.type = type
        self.location = location
        self.image = image
        self.phone = phone
        self.description = description
        self.isVisited = isVisited
        self.rating = rating
    }
}
