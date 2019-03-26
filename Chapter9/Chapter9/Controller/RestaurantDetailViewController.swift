//
//  RestaurantDetailViewController.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 22/03/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController {
    @IBOutlet private var restaurantImageView: UIImageView!
    @IBOutlet private var restaurantNameLabel: UILabel!
    @IBOutlet private var restaurantTypeLabel: UILabel!
    @IBOutlet private var restaurantLocationLabel: UILabel!

    private var restaurantTextName = ""
    private var restaurantTextType = ""
    private var restaurantTextLocation = ""
    private var restaurantTextImageView = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        restaurantTypeLabel.text = restaurantTextType
        restaurantNameLabel.text = restaurantTextName
        restaurantLocationLabel.text = restaurantTextLocation
        restaurantImageView.image = UIImage(named: restaurantTextImageView)
    }

    public func setupInfoCell(restaurant: Restaurant) {
        restaurantTextName = restaurant.name
        restaurantTextType = restaurant.type
        restaurantTextLocation = restaurant.location
        restaurantTextImageView = restaurant.image
    }
}
