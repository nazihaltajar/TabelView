//
//  RestaurantDetailViewController.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 22/03/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController {
    @IBOutlet var restaurantImageView: UIImageView!
    @IBOutlet var restaurantName: UILabel!
    @IBOutlet var restaurantType: UILabel!
    @IBOutlet var restaurantLocation: UILabel!

    var restaurant = Restaurant()

    override func viewDidLoad() {
        super.viewDidLoad()

        restaurantImageView.image = UIImage(named: restaurant.image)
        restaurantName.text = restaurant.name
        restaurantType.text = restaurant.type
        restaurantLocation.text = restaurant.location
    }
}
