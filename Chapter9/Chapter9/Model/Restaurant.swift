//
//  Restaurant.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 11/04/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import Foundation

class Restaurant {
    var name: String
    var type: String
    var location: String
    var image: Data?
    var phone: String
    var description: String
    var isVisited: Bool
    var cellType: CellIdentifier = CellIdentifier.restaurantCellIdentifier
    var rating: String

    init(name: String = "", type: String = "", location: String = "", image: Data? = Data(),
         phone: String = "", description: String = "", isVisited: Bool = false, rating: String = " ") {
        self.name = name
        self.type = type
        self.location = location
        self.image = image
        self.phone = phone
        self.description = description
        self.isVisited = isVisited
        self.rating = rating
        var dictionary: [String: Any] {
            return ["name": name, "type": type, "location": location, "image": image ?? Data(),
                    "phone": phone, "description": description, "isVisited": isVisited, "rating": rating]
        }
    }

    convenience init(dictionary: [String: Any]) {
        self.init(name: dictionary["name"] as? String ?? "",
                  type: dictionary["type"] as? String ?? "",
                  location: dictionary["location"] as? String ?? "",
                  image: dictionary["image"] as? Data,
                  phone: dictionary["phone"] as? String ?? "",
                  description: dictionary["description"] as? String ?? "",
                  isVisited: dictionary["isVisited"] as? Bool ?? false,
                  rating: dictionary["rating"] as? String ?? "")
    }

    convenience init (restaurant: RestaurantMO) {
       self.init(name: restaurant.name ?? "", type: restaurant.type ?? "", location: restaurant.location ?? "",
                 image: restaurant.image ?? Data(), phone: restaurant.phone ?? "", description: restaurant.summary ?? "",
                 isVisited: restaurant.isVisited, rating: restaurant.rating ?? "")
    }

    func toDictionary() -> [String: Any] {
        return ["name": name, "type": type, "location": location,
                "phone": phone, "description": description, "isVisited": isVisited, "rating": rating ]
    }
}
