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

    private let deleteText = "delete"
    private let shareText = "share"
    private let tickImageName = "tick"
    private let undoImageName = "undo"
    private let heartImageName = "heart-tick"
    private var restaurants = [Restaurant]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let restaurantGroup = RestaurantGroup()
        restaurants = restaurantGroup.restaurants
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showRestaurantDetail" {
                if let indexPath = tableView.indexPathForSelectedRow {

                    guard let destinationController = segue.destination as? RestaurantDetailViewController else { return }
                    destinationController.restaurant = restaurants[indexPath.row]
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

            var activityController: UIActivityViewController

            if let imageToShare = UIImage(named: self.restaurants[indexPath.row].image) {
                activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
            } else {
                activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
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
        return restaurants.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "restaurantCellIdentifier"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RestaurantTableViewCell else {
            return UITableViewCell()
        }

        cell.nameLabel.text = restaurants[indexPath.row].name
        cell.thumbnailImageView.image = UIImage(named: restaurants[indexPath.row].image)
        cell.locationLabel.text = restaurants[indexPath.row].location
        cell.typeLabel.text = restaurants[indexPath.row].type
        cell.accessoryType = restaurants[indexPath.row].isVisited ? .checkmark : .none

        return cell
    }
}
