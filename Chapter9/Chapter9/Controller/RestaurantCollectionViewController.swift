//
//  RestaurantCollectionViewController.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 19/05/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class RestaurantCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return database.numberOfRestaurants()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mycell", for: indexPath) as! RestaurantCollectionViewCell
        let restaurant: Restaurant = database.restaurantAtIndexpath(indexPath: indexPath)!

        if let image = restaurant.image {
            cell.addImage(image: image)
        } else {
            database.uploadImage(restaurant: restaurant, verified: {(image) in
            cell.addImage(image: image)
            })
        }
        cell.addName(restaurant: restaurant)

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RestaurantDetailViewController") as? RestaurantDetailViewController else { return }

        vc.restaurantDetails = database.restaurantAtIndexpath(indexPath: indexPath)
        self.navigationController?.pushViewController(vc, animated: true)

    }
}
