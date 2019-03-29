//
//  RestaurantTableViewCell.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 15/03/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var thumbnailImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        thumbnailImageView.layer.cornerRadius = thumbnailImageView.bounds.width / 2
        thumbnailImageView.clipsToBounds  = true
    }

    public func setupInfo(object: Restaurant) {
        nameLabel.text = object.name
        locationLabel.text = object.location
        typeLabel.text = object.type
        thumbnailImageView.image = UIImage(named: object.image)
    }
}
