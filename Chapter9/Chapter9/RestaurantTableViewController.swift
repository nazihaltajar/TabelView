//
//  RestaurantTableViewController.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 15/03/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import UIKit

class RestaurantTableViewController: UIViewController {
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
    let tickImageName = "tick"
    let undoImageName = "undo"
    let heartImageName = "heart-tick"
}

extension RestaurantTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let optionMenu = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let callActionHandler = {(action: UIAlertAction) -> Void in
            let alertMessage = UIAlertController(
                title: "Service Unavalible",
                message: "Sorry, tha call feature is not avalible yet. Please retry later.",
                preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.present(alertMessage, animated: true, completion: nil)
        }

        let callAction = UIAlertAction (title: "Call" + "123-000-\(indexPath.row)", style: .default, handler: callActionHandler)
        let checkInAction = UIAlertAction(title: "Check in", style: .default, handler: {
            (_: UIAlertAction) in
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .checkmark
            self.restaurantIsVisited[indexPath.row] = true
        })

        optionMenu.addAction(callAction)
        optionMenu.addAction(checkInAction)
        optionMenu.addAction(cancelAction)

        present(optionMenu, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: false)

        if let popoverController = optionMenu.popoverPresentationController {
            if let cell = tableView.cellForRow(at: indexPath) {
                popoverController.sourceView = cell
                popoverController.sourceRect = cell.bounds
            }
        }
    }

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
        checkInAction.backgroundColor = .green

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
