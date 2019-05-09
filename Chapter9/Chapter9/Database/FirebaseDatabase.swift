//
//  FirebaseDatabase.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 02/05/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage

class FirebaseDatabase {
    weak var delegate: DatabaseContentProtocol?
    var restaurants: [Restaurant] = [Restaurant]()
    let db: Firestore
    let storage: Storage

    init() {
        FirebaseApp.configure()
        db = Firestore.firestore()
        storage = Storage.storage()
    }
}

extension FirebaseDatabase: DatabaseProtocol {
    func searchRestaurant(restaurantName: String, completion: @escaping ([Restaurant]) -> Void) {
        if numberOfRestaurants() > 0 {
           completion(restaurants.filter({
                $0.name.contains(restaurantName)
            }))
        }
    }

    func deleteRestaurant(restaurant: Restaurant, completion: @escaping (Bool) -> Void) {
        db.collection("restaurants").whereField("name", isEqualTo: restaurant.name).getDocuments {querySnapshot, err in
        if let err = err {
            print ("Error \(err)")
            return
        } else {
            guard let querySnapshot = querySnapshot else { return }

            for fileStored in querySnapshot.documents {
                let storageReference = self.storage.reference().child("\(restaurant.name).png")
                storageReference.delete {error in
                if let err = error {
                    print(err)
                    completion(false)
                } else {
                    print ("File deleted successfully")
                    }
                }
                fileStored.reference.delete()
            }
                if let myRestaurantIndex = self.restaurants.firstIndex ( where: {$0.name ==  restaurant.name}) {
                    let indexpath = IndexPath(row: myRestaurantIndex, section: 0)
                    self.delegate?.willChangeContent()
                    self.restaurants.remove(at: myRestaurantIndex)
                    self.delegate?.didDelete(indexPath: indexpath)
                    self.delegate?.didChangeContent()
                    completion(true)
                }
            }

        }
    }

    func updateRestaurant(restaurant: Restaurant, completion: @escaping (Bool) -> Void) {
        db.collection("restaurants").whereField("name", isEqualTo: restaurant.name).getDocuments {querySnapshot, err in
            if let err = err {
                print("error\(err)")
                completion(false)
                return
            } else {
                guard let querySnapshot = querySnapshot else { return }

                for file in querySnapshot.documents {
                    let myCollection = self.db.collection("restaurants").document(file.documentID)
                        myCollection.updateData([
                            "rating": restaurant.rating,
                            "isVisited": restaurant.isVisited
                            ])

                    if let index = self.restaurants.firstIndex(where: { $0.name == restaurant.name}) {
                       let indexpath = IndexPath(row: index, section: 0)

                        self.delegate?.willChangeContent()
                        self.restaurants[index] = restaurant
                        self.delegate?.didUpdate(indexPath: indexpath)
                        print ("document updated")
                        self.delegate?.didChangeContent()
                        completion(true)
                    }
                }
            }
        }
    }

    func saveRestaurant(restaurant: Restaurant, completion: @escaping (Bool) -> Void) {
        let storageReference = storage.reference().child("\(restaurant.name).png")
        guard let myImage = restaurant.image else { return }

        storageReference.putData(myImage, metadata: nil, completion: {(_, error) in
            guard error == nil else {
                completion(false)
                print(error as Any)
                return
            }

            self.db.collection("restaurants").addDocument(data: restaurant.toDictionary()) { err in
            if let err = err {
                print("Error adding doc : \(err)")
                completion(false)
            } else {
                print("Document added")
                self.delegate?.willChangeContent()
                self.restaurants.append(restaurant)
                self.delegate?.didInsert(indexPath: IndexPath(row: self.numberOfRestaurants() - 1, section: 0))
                self.delegate?.didChangeContent()
                completion (true)
            }
        }
        })
    }

    func uploadImage(restaurant: Restaurant, verified: @escaping (Data) -> Void) {
        DispatchQueue.main.async {
            let reference = self.storage.reference().child("\(restaurant.name).png")
            reference.getData(maxSize: 15 * 1024 * 1024) {(data, _) in
                if let mydata = data {
                    verified(mydata)
                } else {
                    print ("failed to upload image ")
                }
            }
        }
    }

    func reloadData() {
        db.collection("restaurants").getDocuments {(querySnapshot, err) in
            if let err = err {
                print (err)
            } else {
                self.delegate?.willChangeContent()
            }
            var x = 0

            guard let snapshot = querySnapshot else { return }
                snapshot.documentChanges.forEach { document in
                    if document.type == .added {
                        self.restaurants.append(Restaurant(dictionary: document.document.data()))
                    }
                    self.delegate?.didInsert(indexPath: IndexPath(row: x, section: 0))
                    x = x + 1
                }
            self.delegate?.didChangeContent()
        }
    }

    func restaurantAtIndexpath(indexPath: IndexPath) -> Restaurant? {
        return restaurants[indexPath.row]
    }

    func numberOfRestaurants() -> Int {
        return restaurants.count
    }
}
