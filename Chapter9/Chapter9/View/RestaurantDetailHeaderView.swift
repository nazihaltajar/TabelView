//
//  RestaurantDetailHeaderView.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 27/03/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import UIKit

class RestaurantDetailHeaderView: UIView {

    @IBOutlet var heartImageView: UIImageView!
    @IBOutlet var headerImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var typeLabel: UILabel! {
        didSet {
            typeLabel.layer.cornerRadius = 5.0
            typeLabel.layer.masksToBounds = true
        }
    }

    public func setupHeaderView(restaurantDetails: Restaurant) {
        headerImageView.image = UIImage(named: restaurantDetails.name)
        heartImageView.isHidden = (restaurantDetails.isVisited) ? false : true
        nameLabel.text = restaurantDetails.name
        typeLabel.text = restaurantDetails.type
    }
}
