//
//  RestaurantTableViewController.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 15/03/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

enum CellIdentifier: String {
    case restaurantCellIdentifier
}

protocol CustomCell: class {
    var cellType: CellIdentifier { get }
    func configure(withModel: Restaurant)
    func setImage(data: Data)
    func removeImage()
}

class RestaurantTableViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var emptyRestaurantView: UIView!
    @IBAction private func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }

    private let onboardingStoryboard = "Onboarding"
    private let deleteText = "delete"
    private let shareText = "share"
    private let tickImageName = "tick"
    private let undoImageName = "undo"
    private let heartImageName = "heart-tick"

    var searchController: UISearchController!
    var searchResults: [Restaurant] = []
    private var activityController: UIActivityViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self as UIViewControllerPreviewingDelegate, sourceView: view)
        }
        definesPresentationContext = true
        database.delegate = self
        database.reloadData()
        searchForResults()
        customizationNavigationBar()

        tableView.backgroundView = emptyRestaurantView
        tableView.backgroundView?.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presentWalktrough()
        navigationController?.hidesBarsOnSwipe = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestaurantDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let destinationController = segue.destination as? RestaurantDetailViewController else { return }

                destinationController.restaurantDetails =
                    (searchController.isActive) ? searchResults[indexPath.row] : database.restaurantAtIndexpath(indexPath: indexPath)
            }
        }
    }

    private func hideBackgroundView() {
        tableView.backgroundView?.isHidden = true
        tableView.separatorStyle = .singleLine
    }

    private func showBackgroundView() {
        tableView.backgroundView?.isHidden = false
        tableView.separatorStyle = .none
    }

    private func presentWalktrough() {
        if UserDefaults.standard.bool(forKey: "hasViewedWalkthrough") { return }
        let storyboard = UIStoryboard(name: onboardingStoryboard, bundle: nil)
        if let walkthroughViewController = storyboard.instantiateViewController(withIdentifier: "WalktroughViewController") as? WalktroughViewController {
            present(walkthroughViewController, animated: true, completion: nil)
        }
    }

    func prepareNotification() {
        if database.numberOfRestaurants() <= 0 { return }
        let randomNum = Int.random(in: 0..<database.numberOfRestaurants())
        let index = IndexPath(row: randomNum, section: 0)
        let suggestedRestaurant = database.restaurantAtIndexpath(indexPath: index)
        let content = UNMutableNotificationContent()

        content.title = "Restaurant Recomandation"
        content.subtitle = "Try new food today"
        content.body = "I recommend you to check out \(suggestedRestaurant?.name ?? ""). The restaurant is one of your favourites. It is located at \(suggestedRestaurant?.location ?? "").Would you like to give it a try?"
        content.sound = UNNotificationSound.default
        content.userInfo = ["phone": suggestedRestaurant?.phone ?? ""]

        let tempDirURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let tempFileURL = tempDirURL.appendingPathComponent("suggested-restaurant.jpg")

        if let imageData = suggestedRestaurant?.image, let image = UIImage(data: imageData) {
            try? image.jpegData(compressionQuality: 1.0)?.write(to: tempFileURL)
            if let restaurantImage = try? UNNotificationAttachment(identifier: "restaurantImage", url: tempFileURL, options: nil) {
                content.attachments = [restaurantImage]
            }
        }
        let categoryIdentifier = "foodpin.restaurantaction"
        let makeReservationAction = UNNotificationAction(identifier: "foodpin.makeReservation", title: "Reserve a table", options: [.foreground])
        let cancelAction = UNNotificationAction(identifier: "foodpin.cancel", title: "Later", options: [])
        let category = UNNotificationCategory(identifier: categoryIdentifier, actions: [makeReservationAction, cancelAction], intentIdentifiers: [], options: [])

        UNUserNotificationCenter.current().setNotificationCategories([category])
        content.categoryIdentifier = categoryIdentifier

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "foodpin.restaurantSuggestion", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    public func searchForResults() {
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "RestaurantTable.searchPlaceholder".localized
        searchController.searchBar.barTintColor = .black
        searchController.searchBar.tintColor = .customColor
    }

    public func customizationNavigationBar() {
        navigationController?.setNavigationBarBackgroundImageTransparent()
        navigationController?.navigationBar.prefersLargeTitles = true
        if let customFont = UIFont(name: "Rubik-Medium", size: 40.0) {
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:
                UIColor.customColor, NSAttributedString.Key.font: customFont]
        }
    }
}

extension RestaurantTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let checkInAction = UIContextualAction(style: .normal, title: "checkIn") {(_, _, completionHandler) in
            if let restaurantCheck = database.restaurantAtIndexpath(indexPath: indexPath) {
                restaurantCheck.isVisited = true
                database.updateRestaurant(restaurant: restaurantCheck, completion: {_ in})}

            completionHandler(true)
        }

        let undoCheckIn = UIContextualAction(style: .normal, title: "undoCheckIn") {( _, _, completionHandler) in
            let restaurantToUndo = database.restaurantAtIndexpath(indexPath: indexPath)
            restaurantToUndo?.isVisited = false
            database.updateRestaurant(restaurant: restaurantToUndo ?? Restaurant(), completion: {_ in})

            completionHandler(true)
        }

        checkInAction.image = UIImage(named: tickImageName)
        checkInAction.backgroundColor = .checkInColor
        undoCheckIn.image = UIImage(named: undoImageName)
        undoCheckIn.backgroundColor = .undoCheckInColor

        return (database.restaurantAtIndexpath(indexPath: indexPath)?.isVisited ?? false) ? UISwipeActionsConfiguration(actions: [undoCheckIn])
            : UISwipeActionsConfiguration (actions: [checkInAction])
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: deleteText) {(_, _, completionHandler) in
            if let myRestaurant = database.restaurantAtIndexpath(indexPath: indexPath) {
                database.deleteRestaurant(restaurant: myRestaurant, completion: {_ in})
            }
            completionHandler(true)
        }

        let shareAction = UIContextualAction(style: .normal, title: shareText) {(_, _, completionHandler) in

            let defaultText = "Just checking in at " + (database.restaurantAtIndexpath(indexPath: indexPath)?.name ?? "")

            if let restaurantImage = database.restaurantAtIndexpath(indexPath: indexPath)?.image,
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
        let count = searchController.isActive ? searchResults.count : database.numberOfRestaurants()
        return count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        database.numberOfRestaurants() > 0 ? hideBackgroundView() : showBackgroundView()

        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType: CellIdentifier = CellIdentifier.restaurantCellIdentifier
        let restaurant: Restaurant?
        let customCell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as? CustomCell

        if searchController.isActive {
            if searchResults.count > 0 {
                restaurant = searchResults[indexPath.row]
            } else {
                print("there are no elements")
                return UITableViewCell()
            }
        } else {
            restaurant = database.restaurantAtIndexpath(indexPath: indexPath)
        }

        customCell?.configure(withModel: restaurant ?? Restaurant())
        customCell?.removeImage()
        if let image = restaurant?.image {
            customCell?.setImage(data: image)
        } else {
            database.uploadImage(restaurant: restaurant ?? Restaurant(), verified: {(image) in
                customCell?.setImage(data: image)
            })
        }
        return (customCell as? UITableViewCell) ?? UITableViewCell()
    }
}

extension RestaurantTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            database.searchRestaurant(restaurantName: searchText) { restaurants in
                self.searchResults = restaurants
                self.tableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !searchController.isActive
    }
}

extension RestaurantTableViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location),
              let cell = tableView.cellForRow(at: indexPath) else { return nil }
        guard let restaurantDetailViewController = storyboard?.instantiateViewController(withIdentifier: "RestaurantDetailViewController") as?
            RestaurantDetailViewController else { return nil }

        let selectedRestaurant = database.restaurantAtIndexpath(indexPath: indexPath )
        restaurantDetailViewController.restaurantDetails = selectedRestaurant
        restaurantDetailViewController.preferredContentSize = CGSize(width: 0.0, height: 460.0)
        previewingContext.sourceRect = cell.frame

        return restaurantDetailViewController
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}

extension RestaurantTableViewController: DatabaseContentProtocol {
    func willChangeContent() {
        tableView.beginUpdates()
    }

    func didChangeContent() {
        tableView.endUpdates()
        prepareNotification()
    }

    func didInsert(indexPath: IndexPath) {
        tableView.insertRows(at: [indexPath], with: .fade)
    }

    func didDelete(indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .fade)
    }

    func didUpdate(indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
}
