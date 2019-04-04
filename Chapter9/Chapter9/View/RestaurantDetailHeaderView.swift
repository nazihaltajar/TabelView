//
//  RestaurantDetailHeaderView.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 27/03/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import UIKit

class RestaurantDetailHeaderView: UIView {
    @IBOutlet private weak var shadowTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var headerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var heartImageView: UIImageView!
    @IBOutlet private weak var headerImageView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var typeLabel: UILabel! {
        didSet {
            typeLabel.layer.cornerRadius = 5.0
            typeLabel.layer.masksToBounds = true
        }
    }

    public func setContentOffset(_ offset: CGFloat) {
        headerViewTopConstraint.constant = offset
        shadowTopConstraint.constant = offset
    }

    public func setupHeaderView(restaurantDetails: Restaurant) {
        headerImageView.image = UIImage(named: restaurantDetails.name)
        heartImageView.isHidden = (restaurantDetails.isVisited) ? false : true
        nameLabel.text = restaurantDetails.name
        typeLabel.text = restaurantDetails.type
    }
}
