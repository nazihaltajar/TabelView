//
//  RestaurantTableViewController.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 15/03/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import UIKit

class RestaurantTableViewController: UITableViewController {
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
    var actionButtonTitle = ""
    var actionButtonHandler = { (_: UIAlertAction) in }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.cellLayoutMarginsFollowReadableWidth = true
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantNames.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCell = tableView.cellForRow(at: indexPath) else { return }

        switch restaurantIsVisited[indexPath.row] {
        case true:
            actionButtonTitle = "Undo check in"
            actionButtonHandler = { (_: UIAlertAction) in
                selectedCell.accessoryType = .none
                self.restaurantIsVisited[indexPath.row] = false
            }
        default:
            actionButtonTitle = "Check In"
            actionButtonHandler = { (_: UIAlertAction) in
                selectedCell.accessoryType = .checkmark
                self.restaurantIsVisited[indexPath.row] = true
            }
        }

        let optionsAlertController = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: .actionSheet)
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
        let checkInAction = UIAlertAction(title: actionButtonTitle, style: .default, handler: actionButtonHandler)

        optionsAlertController.addAction(callAction)
        optionsAlertController.addAction(checkInAction)
        optionsAlertController.addAction(cancelAction)

        present(optionsAlertController, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: false)

        if let popoverController = optionsAlertController.popoverPresentationController {
            popoverController.sourceView = selectedCell
            popoverController.sourceRect = selectedCell.bounds
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "dataCellIdentifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestaurantTableViewCell

        cell.nameLabel.text = restaurantNames[indexPath.row]
        cell.thumbnailImageView.image = UIImage(named: restaurantNames[indexPath.row])
        cell.locationLabel.text = restaurantLocations[indexPath.row]
        cell.typeLabel.text = restaurantTypes[indexPath.row]
        cell.accessoryType = restaurantIsVisited[indexPath.row] ? .checkmark : .none

        return cell
    }
}
