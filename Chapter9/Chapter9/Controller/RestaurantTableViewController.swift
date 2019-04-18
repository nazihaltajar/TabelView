//
//  RestaurantTableViewController.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 15/03/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import UIKit
import CoreData

enum CellIdentifier: String {
    case restaurantCellIdentifier
}

protocol CustomCell: class {
    var cellType: CellIdentifier { get }
    func configure(withModel: Restaurant)
}

class RestaurantTableViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var emptyRestaurantView: UIView!
    @IBAction private func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }

    private let deleteText = "delete"
    private let shareText = "share"
    private let tickImageName = "tick"
    private let undoImageName = "undo"
    private let heartImageName = "heart-tick"
    private var restaurantsMO = [RestaurantMO]()

    var activityController: UIActivityViewController?
    var fetchResultController: NSFetchedResultsController<RestaurantMO>!
    var searchController: UISearchController!
    var searchResults: [Restaurant] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        definesPresentationContext = true
        fetchResults()
        searchForResults()
        customizationNavigationBar()

        tableView.backgroundView = emptyRestaurantView
        tableView.backgroundView?.isHidden = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestaurantDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let destinationController = segue.destination as? RestaurantDetailViewController else { return }

                destinationController.restaurantDetails =
                    (searchController.isActive) ? searchResults[indexPath.row] : Restaurant(restaurant: restaurantsMO[indexPath.row])
            }
        }
    }

    public func searchForResults() {
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search restaurants..."
        searchController.searchBar.barTintColor = .black
        searchController.searchBar.tintColor = .customColor
    }

    public func fetchResults() {
        let fetchRequest: NSFetchRequest<RestaurantMO> = RestaurantMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

            let context = database.context
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    restaurantsMO = fetchedObjects
                }
            } catch {
                print(error)
            }
    }

    public func customizationNavigationBar() {
        navigationController?.setNavigationBarBackgroundImageTransparent()
        navigationController?.navigationBar.prefersLargeTitles = true
        if let customFont = UIFont(name: "Rubik-Medium", size: 40.0) {
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:
                UIColor.customColor, NSAttributedString.Key.font: customFont]
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.hidesBarsOnSwipe = true
    }
}

extension RestaurantTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let checkInAction = UIContextualAction(style: .normal, title: "checkIn") {(_, _, completionHandler) in
            let restaurantCheck = self.restaurantsMO[indexPath.row]
            let restaurant = Restaurant(restaurant: restaurantCheck)
            restaurant.isVisited = true
            database.updateRestaurant(restaurant: restaurant)

            completionHandler(true)
        }

        let undoCheckIn = UIContextualAction(style: .normal, title: "undoCheckIn") {( _, _, completionHandler) in
            let restaurantToUndo = self.restaurantsMO[indexPath.row]
            let restaurant = Restaurant(restaurant: restaurantToUndo)
            restaurant.isVisited = false
            database.updateRestaurant(restaurant: restaurant)

            completionHandler(true)
        }

        checkInAction.image = UIImage(named: tickImageName)
        checkInAction.backgroundColor = .checkInColor
        undoCheckIn.image = UIImage(named: undoImageName)
        undoCheckIn.backgroundColor = .undoCheckInColor

        return restaurantsMO[indexPath.row].isVisited ? UISwipeActionsConfiguration(actions: [undoCheckIn]) : UISwipeActionsConfiguration (actions: [checkInAction])
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: deleteText) {(_, _, completionHandler) in
                let restaurantToDelete = self.fetchResultController.object(at: indexPath)
                let myRestaurant = Restaurant(restaurant: restaurantToDelete)
                database.deleteRestaurant(restaurant: myRestaurant)

            completionHandler(true)
        }

        let shareAction = UIContextualAction(style: .normal, title: shareText) {(_, _, completionHandler) in

            let defaultText = "Just checking in at " + (self.restaurantsMO[indexPath.row].name ?? "")

            if let restaurantImage = self.restaurantsMO[indexPath.row].image,
                let imageToShare = UIImage(data: restaurantImage as Data ) {
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
        let count = searchController.isActive ? searchResults.count : restaurantsMO.count
        return count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        restaurantsMO.count > 0 ? hideBackgroundView() : showBackgroundView()
        return 1
    }

    func hideBackgroundView() {
        tableView.backgroundView?.isHidden = true
        tableView.separatorStyle = .singleLine
    }

    func showBackgroundView() {
        tableView.backgroundView?.isHidden = false
        tableView.separatorStyle = .none
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType: CellIdentifier = CellIdentifier.restaurantCellIdentifier
        let restaurant: Restaurant?
        if searchController.isActive && indexPath.row < searchResults.count {
            restaurant = searchResults[indexPath.row]
        } else {
            restaurant = Restaurant(restaurant: restaurantsMO[indexPath.row])
        }
        let customCell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as? CustomCell
        customCell?.configure(withModel: restaurant ?? Restaurant())

        return customCell as? UITableViewCell ?? UITableViewCell()
    }
}

extension RestaurantTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any,
                    at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }

        if let fetchedObjects = controller.fetchedObjects {
            restaurantsMO = fetchedObjects as! [RestaurantMO]
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

extension RestaurantTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            DispatchQueue.global(qos: .background).async {
                self.searchResults = database.searchRestaurant(restaurantName: searchText)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !searchController.isActive
    }
}
