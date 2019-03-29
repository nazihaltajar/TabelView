//
//  RestaurantTableViewController.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 15/03/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import UIKit

class RestaurantTableViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!

    private let deleteText = "delete"
    private let shareText = "share"
    private let tickImageName = "tick"
    private let undoImageName = "undo"
    private let heartImageName = "heart-tick"
    private var restaurants = [Restaurant]()
    var activityController: UIActivityViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        let restaurantGroup = RestaurantGroup()
        restaurants = restaurantGroup.restaurants
        customizationNavigationBar()
    }

    private func customizationNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        if let customFont = UIFont(name: "Rubik-Medium", size: 40.0) {
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:
                UIColor.customColor, NSAttributedString.Key.font: customFont]
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestaurantDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let destinationController = segue.destination as? RestaurantDetailViewController else { return }

                destinationController.restaurantDetails = restaurants[indexPath.row]
            }
        }
    }
}

extension RestaurantTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let checkInAction = UIContextualAction(style: .normal, title: "checkIn") {(_, _, completionHandler) in
            let cell = tableView.cellForRow(at: indexPath)
            self.restaurants[indexPath.row].isVisited = true
            let imageView = UIImageView(image: UIImage(named: self.heartImageName))
            cell?.accessoryView = imageView

            completionHandler(true)
        }

        let undoCheckIn = UIContextualAction(style: .normal, title: "undoCheckIn") {( _, _, completionHandler) in
            let cell = tableView.cellForRow(at: indexPath)
            self.restaurants[indexPath.row].isVisited = false
            cell?.accessoryView = .none

            completionHandler(true)
        }

        checkInAction.image = UIImage(named: tickImageName)
        checkInAction.backgroundColor = .checkInColor
        undoCheckIn.image = UIImage(named: undoImageName)
        undoCheckIn.backgroundColor = .undoCheckInColor

        return restaurants[indexPath.row].isVisited ? UISwipeActionsConfiguration(actions: [undoCheckIn]) : UISwipeActionsConfiguration (actions: [checkInAction])
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: deleteText) {(_, _, completionHandler) in
            self.restaurants.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)

            completionHandler(true)
        }

        let shareAction = UIContextualAction(style: .normal, title: shareText) {(_, _, completionHandler) in
            let defaultText = "Just checking in at " + self.restaurants[indexPath.row].name

            if let imageToShare = UIImage(named: self.restaurants[indexPath.row].image) {
                self.activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
            } else {
                self.activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
            }

            if let popoverController = self.activityController?.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }
            guard let activityViewController = self.activityController else { return }

            self.present(activityViewController, animated: true, completion: nil)
            completionHandler(true)
        }

        deleteAction.image = UIImage(named: deleteText)
        deleteAction.backgroundColor = .deleteColor
        shareAction.image = UIImage(named: shareText)
        shareAction.backgroundColor = .checkInColor

        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])

        return swipeConfiguration
    }
}

extension RestaurantTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "restaurantCellIdentifier"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RestaurantTableViewCell else {
            return UITableViewCell()
        }

        cell.setupInfo(object: restaurants[indexPath.row] )

        return cell
    }
}
