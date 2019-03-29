//
//  RestaurantDetailViewController.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 22/03/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController {
    @IBOutlet private weak var restaurantTableView: UITableView!
    @IBOutlet private weak var restaurantHeaderView: RestaurantDetailHeaderView!

    var restaurantDetails: Restaurant?

    override func viewDidLoad() {
        super.viewDidLoad()

        restaurantTableView.delegate = self
        restaurantTableView.dataSource = self

        setupInfoCell()
    }
}

extension RestaurantDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        restaurantHeaderView.setContentOffset(scrollView.contentOffset.y)
    }
}

extension RestaurantDetailViewController: UITableViewDelegate {
}

extension RestaurantDetailViewController: UITableViewDataSource {
    private func setupInfoCell() {
        guard let restaurantDetail = restaurantDetails else { return }

        restaurantHeaderView.setupHeaderView(restaurantDetails: restaurantDetail)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailIconTextCell.self),
                                                     for: indexPath) as! RestaurantDetailIconTextCell

            cell.iconImageView.image = UIImage(named: "phone")
            cell.shortTextLabel.text = restaurantDetails?.phone
            cell.selectionStyle = .none

            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailIconTextCell.self),
                                                     for: indexPath) as! RestaurantDetailIconTextCell

            cell.iconImageView.image = UIImage(named: "map")
            cell.shortTextLabel.text = restaurantDetails?.location
            cell.selectionStyle = .none

            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailTextCell.self),
                                                     for: indexPath) as! RestaurantDetailTextCell

            cell.descriptionLabel.text = restaurantDetails?.description
            cell.selectionStyle = .none

            return cell

        default:
            fatalError("Failed to instantiate the table view cell for detail view controller")
        }
    }
}
