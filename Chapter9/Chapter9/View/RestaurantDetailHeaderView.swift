//
//  RestaurantDetailHeaderView.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 27/03/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import UIKit

class RestaurantDetailHeaderView: UIView {

    @IBOutlet private var dimConstraint: NSLayoutConstraint!
    @IBOutlet private var topConstraint: NSLayoutConstraint!
    @IBOutlet private var heartImageView: UIImageView!
    @IBOutlet private var headerImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var typeLabel: UILabel! {
        didSet {
            typeLabel.layer.cornerRadius = 5.0
            typeLabel.layer.masksToBounds = true
        }
    }

    public func setContentOffset(_ offset: CGFloat) {
        topConstraint.constant = offset
        dimConstraint.constant = offset
    }

    public func setupHeaderView(restaurantDetails: Restaurant) {
        headerImageView.image = UIImage(named: restaurantDetails.name)
        heartImageView.isHidden = (restaurantDetails.isVisited) ? false : true
        nameLabel.text = restaurantDetails.name
        typeLabel.text = restaurantDetails.type
    }
}
