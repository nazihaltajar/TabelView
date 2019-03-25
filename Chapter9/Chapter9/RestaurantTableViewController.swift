//
//  RestaurantTableViewController.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 15/03/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import UIKit

class RestaurantTableViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!

    var restaurantNames = ["Cafe Deadend", "Homei", "Teakha", "Cafe Loisl", "Petite Oyster", "For Kee Restaurant",
                           "Po's Atelier", "Bourke Street Bakery", "Haigh's Chocolate", "Palomino Espresso", "Upstate",
                           "Traif", "Graham Avenue Meats And Deli", "Waffle & Wolf", "Five Leaves", "Cafe Lore", "Confessional",
                           "Barrafina", "Donostia", "Royal Oak", "CASK Pub and Kitchen"]
    var restaurantLocations = ["Hong kong", "Hong kong", "Hong kong", "Hong kong", "Hong kong", "Hong kong", "Hong kong", "Sydney",
                               "Sydney", "Sydney", "New York", "New York", "New York", "New York", "New York", "New York", "New York",
                               "New York", "London", "London", "London", "London"]
    var restaurantTypes = ["Coffee & Tea Shop", "Cafe", "Tea House", "Australian / Causual Drink", "French", "Bakery", "Bakery",
                           "Chocolate", "Cafe", "American / Seafood", "American", "American", "Breakfast & Brunch", "Coffee & Tea",
                           "Coffee & Tea", "Latin American", "Spanish", "Spanish", "Spanish", "British", "Thai"]
    var restaurantIsVisited = Array(repeating: false, count: 21)
    var activityController: UIActivityViewController?

    let deleteText = "delete"
    let shareText = "share"
    private let tickImageName = "tick"
    private let undoImageName = "undo"
    private let heartImageName = "heart-tick"

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showRestaurantDetail" {
                if let indexPath = tableView.indexPathForSelectedRow {

                    guard let destinationController = segue.destination as? RestaurantDetailViewController else { return }
                    destinationController.restaurantImageName = restaurantNames[indexPath.row]
                    destinationController.restaurantTextName = restaurantNames[indexPath.row]
                    destinationController.restaurantTextType = restaurantTypes[indexPath.row]
                    destinationController.restaurantTextLocation = restaurantLocations[indexPath.row]

                }
            }
        }
}

extension RestaurantTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let checkInAction = UIContextualAction(style: .normal, title: "checkIn") {(_, _, completionHandler) in
            let cell = tableView.cellForRow(at: indexPath)
            self.restaurantIsVisited[indexPath.row] = true
            let imageView = UIImageView(image: UIImage(named: self.heartImageName))
            cell?.accessoryView = imageView

            completionHandler(true)
        }

        let undoCheckIn = UIContextualAction(style: .normal, title: "undoCheckIn") {( _, _, completionHandler) in
            let cell = tableView.cellForRow(at: indexPath)
            self.restaurantIsVisited[indexPath.row] = false
            cell?.accessoryView = .none

            completionHandler(true)
        }

        checkInAction.image = UIImage(named: tickImageName)
        checkInAction.backgroundColor = .checkInColor
        undoCheckIn.image = UIImage(named: undoImageName)
        undoCheckIn.backgroundColor = .undoCheckInColor

        return restaurantIsVisited[indexPath.row] ? UISwipeActionsConfiguration(actions: [undoCheckIn]) : UISwipeActionsConfiguration (actions: [checkInAction])
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: deleteText) {(_, _, completionHandler) in
            self.restaurantNames.remove(at: indexPath.row)
            self.restaurantLocations.remove(at: indexPath.row)
            self.restaurantTypes.remove(at: indexPath.row)
            self.restaurantIsVisited.remove(at: indexPath.row)

            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }

        let shareAction = UIContextualAction(style: .normal, title: shareText) {(_, _, completionHandler) in
            let defaultText = "Just checking in at " + self.restaurantNames[indexPath.row]

            guard let activityController = self.activityController else { return }

            if let imageToShare = UIImage(named: self.restaurantNames[indexPath.row]) {
                self.activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
            } else {
                self.activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
            }

            if let popoverController = activityController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }

            self.present(activityController, animated: true, completion: nil)
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
        return restaurantNames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "restaurantCellIdentifier"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RestaurantTableViewCell else {
            return UITableViewCell()
        }

        cell.nameLabel.text = restaurantNames[indexPath.row]
        cell.thumbnailImageView.image = UIImage(named: restaurantNames[indexPath.row])
        cell.locationLabel.text = restaurantLocations[indexPath.row]
        cell.typeLabel.text = restaurantTypes[indexPath.row]
        cell.accessoryType = restaurantIsVisited[indexPath.row] ? .checkmark : .none

        return cell
    }
}
