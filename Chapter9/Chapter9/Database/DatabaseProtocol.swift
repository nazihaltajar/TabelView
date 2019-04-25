//
//  DatabaseProtocol.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 02/05/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import Foundation

protocol DatabaseProtocol {
    var delegate: DatabaseContentProtocol? { get set }
    func searchRestaurant (restaurantName: String, completion: @escaping (([Restaurant]) -> Void))
    func deleteRestaurant(restaurant: Restaurant, completion: @escaping (Bool) -> Void)
    func updateRestaurant(restaurant: Restaurant, completion: @escaping (Bool) -> Void)
    func saveRestaurant(restaurant: Restaurant, completion: @escaping (Bool) -> Void)
    func uploadImage(restaurant: Restaurant, verified: @escaping (Data) -> Void)
    func reloadData()
    func restaurantAtIndexpath(indexPath: IndexPath) -> Restaurant?
    func numberOfRestaurants() -> Int
}

protocol DatabaseContentProtocol: class {
    func willChangeContent()
    func didChangeContent()
    func didInsert(indexPath: IndexPath)
    func didDelete(indexPath: IndexPath)
    func didUpdate(indexPath: IndexPath)
}
