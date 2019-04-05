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
    @IBOutlet private weak var ratingImageView: UIImageView!
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
        ratingImageView.image = UIImage(named: restaurantDetails.rating)

        let scaleTransform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        ratingImageView.transform = scaleTransform
        ratingImageView.alpha = 0

        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.7, options: [], animations: {
            self.ratingImageView.transform = .identity
            self.ratingImageView.alpha = 1
        }, completion: nil)
    }
}
