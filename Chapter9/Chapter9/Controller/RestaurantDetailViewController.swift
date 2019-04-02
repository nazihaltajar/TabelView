//
//  RestaurantDetailViewController.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 22/03/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import UIKit

enum CellTypes: Int {
    case phone
    case location
    case description
}

class RestaurantDetailViewController: UIViewController {
    @IBOutlet private weak var restaurantTableView: UITableView!
    @IBOutlet private weak var restaurantHeaderView: RestaurantDetailHeaderView!

    var restaurantDetails: Restaurant?

    override func viewDidLoad() {
        super.viewDidLoad()

        restaurantTableView.delegate = self
        restaurantTableView.dataSource = self
        customizeNavigationBar()

        setupInfoCell()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    private func customizeNavigationBar() {
        navigationController?.setNavigationBarBackgroundImageTransparent()
        navigationController?.navigationBar.tintColor = .white
        restaurantTableView.contentInsetAdjustmentBehavior = .never
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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

        guard let type = CellTypes(rawValue: indexPath.row ) else { return UITableViewCell() }
        switch type {
        case .phone:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailIconTextCell.self),
                                                     for: indexPath) as! RestaurantDetailIconTextCell

            cell.iconImageView.image = UIImage(named: "phone")
            cell.shortTextLabel.text = restaurantDetails?.phone
            cell.selectionStyle = .none

            return cell
        case .location:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailIconTextCell.self),
                                                     for: indexPath) as! RestaurantDetailIconTextCell

            cell.iconImageView.image = UIImage(named: "map")
            cell.shortTextLabel.text = restaurantDetails?.location
            cell.selectionStyle = .none

            return cell
        case .description:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailTextCell.self),
                                                     for: indexPath) as! RestaurantDetailTextCell

            cell.descriptionLabel.text = restaurantDetails?.description
            cell.selectionStyle = .none

            return cell

        }
    }
}
