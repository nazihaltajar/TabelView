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
    let delete = "delete"
    let share = "share"
}

extension RestaurantTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let optionMenu = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let callActionHandler = {(action: UIAlertAction!) -> Void in
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

     func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: delete) {(_, _, completionHandler) in
            self.restaurantNames.remove(at: indexPath.row)
            self.restaurantLocations.remove(at: indexPath.row)
            self.restaurantTypes.remove(at: indexPath.row)
            self.restaurantIsVisited.remove(at: indexPath.row)

            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }

        let shareAction = UIContextualAction(style: .normal, title: share) {(_, _, completionHandler) in
        let defaultText = "Just checking in at " + self.restaurantNames[indexPath.row]
        let activityController: UIActivityViewController

            if let imageToShare = UIImage(named: self.restaurantNames[indexPath.row]) {
                activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
            } else {
                activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
            }

            self.present(activityController, animated: true, completion: nil)
            completionHandler(true)
        }

        deleteAction.image = UIImage(named: delete)
        deleteAction.backgroundColor = UIColor(red: 231.0/255.0,
                                               green: 76.0/255.0,
                                               blue: 60.0/255.0,
                                               alpha: 1.0)
        shareAction.image = UIImage(named: share)
        shareAction.backgroundColor = UIColor(red: 254.0/255.0,
                                              green: 149.0/255.0,
                                              blue: 38.0/255.0,
                                              alpha: 1.0)

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
