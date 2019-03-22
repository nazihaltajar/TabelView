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

    var restaurantImageName = ""
    var restaurantTextName = ""
    var restaurantTextType = ""
    var restaurantTextLocation = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        restaurantImageView.image = UIImage(named: restaurantImageName)
        restaurantName.text = restaurantTextName
        restaurantType.text = restaurantTextType
        restaurantLocation.text = restaurantTextLocation
    }
}
