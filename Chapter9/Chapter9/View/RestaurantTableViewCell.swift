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

}

extension RestaurantTableViewCell: CustomCell {
    var cellType: CellIdentifier {
        return .restaurantCellIdentifier
    }

    func configure(withModel: Restaurant) {
        nameLabel.text = withModel.name
        locationLabel.text = withModel.location
        typeLabel.text = withModel.type
        thumbnailImageView.image = UIImage(named: withModel.image)
    }
}
