//
//  RestaurantDetailViewController.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 22/03/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController {

    @IBOutlet private var restaurantTableView: UITableView!
    @IBOutlet private var restaurantHeaderView: RestaurantDetailHeaderView!

    var restaurant: Restaurant?
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let myRestaurant = self.restaurant else { return }
        setupHeaderView(setObj: myRestaurant)

    }

    public func setupHeaderView(setObj: Restaurant) {
        restaurantHeaderView.headerImageView.image = UIImage(named: setObj.name)
        restaurantHeaderView.heartImageView.isHidden = (setObj.isVisited) ? false : true
        restaurantHeaderView.nameLabel.text = setObj.name
        restaurantHeaderView.typeLabel.text = setObj.type
    }
}
