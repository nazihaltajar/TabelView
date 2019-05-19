//
//  RestaurantCollectionViewCell.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 19/05/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import UIKit
import Foundation

class RestaurantCollectionViewCell: UICollectionViewCell {

    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var cellName: UILabel!

    func addName(restaurant: Restaurant) {
        cellName.text = restaurant.name
    }

    func addImage(image: Data) {
        cellImage.image = UIImage(data: image)
    }
}
