//
//  RestaurantInfoWithIcon.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 28/03/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import Foundation

class RestaurantInfoWithIcon: IRestaurantInfo {
    var Text: String
    var ImageName: String

    init(Text: String, ImageName: String ) {
        self.Text = Text
        self.ImageName = ImageName
    }
}
