//
//  RestaurantDetailHeaderView.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 27/03/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import UIKit

class RestaurantDetailHeaderView: UIView {

    @IBOutlet var headerImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel! {
        didSet {
            nameLabel.numberOfLines = 0
        }
    }
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var heartImageView: UIImageView!

}
