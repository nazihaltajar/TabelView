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
    @IBOutlet private var restaurantName: UILabel!
    @IBOutlet private var restaurantType: UILabel!
    @IBOutlet private var restaurantLocation: UILabel!

    private var restaurantTextName = ""
    private var restaurantTextType = ""
    private var restaurantTextLocation = ""
    private var restaurantTextImageView = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        restaurantType.text = restaurantTextType
        restaurantName.text = restaurantTextName
        restaurantLocation.text = restaurantTextLocation
        restaurantImageView.image = UIImage(named: restaurantTextImageView)
    }

    public func setupInfoCell(setObj: Restaurant) {
        restaurantTextName = setObj.name
        restaurantTextType = setObj.type
        restaurantTextLocation = setObj.location
        restaurantTextImageView = setObj.image
    }
}
