//
//  RestaurantTableViewController.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 15/03/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import UIKit

class RestaurantTableViewController: UITableViewController {
    var restaurantNames =
        ["Cafe Deadend", "Homei", "Teakha", "Cafe Loisl", "Petite Oyster", "For Kee Restaurant",
        "Po's Atelier", "Bourke Street Bakery", "Haigh's Chocolate", "Palomino Espresso", "Upstate",
        "Traif", "Graham Avenue Meats And Deli", "Waffle & Wolf", "Five Leaves", "Cafe Lore", "Confessional",
        "Barrafina", "Donostia", "Royal Oak", "CASK Pub and Kitchen"]
    var restaurantLocations =
        ["Hong kong", "Hong kong", "Hong kong", "Hong kong", "Hong kong", "Hong kong", "Hong kong", "Sydney",
        "Sydney", "Sydney", "New York", "New York", "New York", "New York", "New York", "New York", "New York",
        "New York", "London", "London", "London", "London"]
    var restaurantTypes =
        ["Coffee & Tea Shop", "Cafe", "Tea House", "Australian / Causual Drink", "French", "Bakery", "Bakery",
         "Chocolate", "Cafe", "American / Seafood", "American", "American", "Breakfast & Brunch", "Coffee & Tea",
         "Coffee & Tea", "Latin American", "Spanish", "Spanish", "Spanish", "British", "Thai"]

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "dataCellIdentifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestaurantTableViewCell

        cell.nameLabel.text = restaurantNames[indexPath.row]
        cell.thumbnailImageView.image = UIImage(named: restaurantNames[indexPath.row])
        cell.locationLabel.text = restaurantLocations[indexPath.row]
        cell.typeLabel.text = restaurantTypes[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantNames.count
    }
}
