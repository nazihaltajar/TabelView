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
    case headerMap
    case map
}

class RestaurantDetailViewController: UIViewController {
    @IBOutlet private weak var restaurantTableView: UITableView!
    @IBOutlet private weak var restaurantHeaderView: RestaurantDetailHeaderView!
    @IBAction func close (segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func rateRestaurant (segue: UIStoryboardSegue) {
        if let rating = segue.identifier {
            self.restaurantDetails?.rating = rating
//            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
//                appDelegate.saveContext()
//            }
            database.saveContext()
            if let restaurantDetails = self.restaurantDetails {
                self.restaurantHeaderView.setupHeaderView(restaurantDetails: restaurantDetails)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    var database = Database()
    var restaurantDetails: RestaurantMO!

    override func viewDidLoad() {
        super.viewDidLoad()

        restaurantTableView.delegate = self
        restaurantTableView.dataSource = self
        customizeNavigationBar()
        setupInfoCell()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let restaurant = restaurantDetails else { return }

        if segue.identifier == "showMap" {
            let destinationController = segue.destination as! MapViewController
            destinationController.restaurant = restaurant
        }
        if segue.identifier == "showReview" {
            let destinationController = segue.destination as! ReviewViewController
            destinationController.restaurant = restaurant
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.setBackButtonTintColor(mycolor: .white)
    }

    private func customizeNavigationBar() {
        navigationController?.setNavigationBarBackgroundImageTransparent()
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
        return 5
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
            cell.descriptionLabel.text = restaurantDetails?.summary
            cell.selectionStyle = .none

            return cell
        case .headerMap:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailSeparatorCell.self),
                                                     for: indexPath) as! RestaurantDetailSeparatorCell
            cell.titleLabel.text = "HOW TO GET HERE"
            cell.selectionStyle = .none

            return cell
        case .map:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailMapCell.self),
                                                     for: indexPath) as! RestaurantDetailMapCell
            if restaurantDetails.location != nil {
                cell.configure(location: restaurantDetails?.location ?? "")
            }
            return cell
        }
    }
}
