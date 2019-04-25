//
//  Database.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 16/04/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import Foundation
import CoreData

class Database: NSObject {
    weak var delegate: DatabaseContentProtocol?
    var fetchResultController: NSFetchedResultsController<RestaurantMO>!
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Chapter9")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    public func reloadData() {
        let fetchRequest: NSFetchRequest<RestaurantMO> = RestaurantMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        do {
            try fetchResultController.performFetch()
        } catch {
            print(error)
        }
    }
}

extension Database: DatabaseProtocol {
    func uploadImage(restaurant: Restaurant, verified: @escaping (Data) -> Void) {
    }

    func numberOfRestaurants() -> Int {
        return fetchResultController.fetchedObjects?.count ?? 0
    }

    func restaurantAtIndexpath(indexPath: IndexPath) -> Restaurant? {
        let restaurantM = fetchResultController.object(at: indexPath)
        let myRestaurant = Restaurant(restaurant: restaurantM)
        return myRestaurant
    }

    func saveRestaurant(restaurant: Restaurant, completion: @escaping (Bool) -> Void) {
        let context = persistentContainer.newBackgroundContext()
        context.perform {
            let restaurantMO = RestaurantMO(context: context)
            restaurantMO.name = restaurant.name
            restaurantMO.location = restaurant.location
            restaurantMO.rating = restaurant.rating
            restaurantMO.phone = restaurant.phone
            restaurantMO.summary = restaurant.description
            restaurantMO.isVisited = restaurant.isVisited
            restaurantMO.image = restaurant.image
            restaurantMO.type = restaurant.type
            do {
                try context.save()
                completion(true)
            } catch {
                completion(false)
            }
        }
    }

    func updateRestaurant(restaurant: Restaurant, completion: @escaping (Bool) -> Void) {
        let context = persistentContainer.newBackgroundContext()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RestaurantMO")
        request.predicate = NSPredicate(format: "name == %@", restaurant.name)
        request.fetchLimit = 1

        context.perform {
            do {
                let restaurantResult = try context.fetch(request)
                if let restaurantMO = restaurantResult.first as? RestaurantMO {
                    restaurantMO.name = restaurant.name
                    restaurantMO.location = restaurant.location
                    restaurantMO.rating = restaurant.rating
                    restaurantMO.phone = restaurant.phone
                    restaurantMO.summary = restaurant.description
                    restaurantMO.isVisited = restaurant.isVisited
                    restaurantMO.image = restaurant.image
                    try context.save()
                    completion(true)
                }
            } catch {
                completion(false)
            }
        }
        return
    }

    func deleteRestaurant(restaurant: Restaurant, completion: @escaping (Bool) -> Void) {
        let context = persistentContainer.newBackgroundContext()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RestaurantMO")
        request.predicate = NSPredicate(format: "name == %@", restaurant.name)
        request.fetchLimit = 1

        context.perform {
            do {
                let restaurantResult = try context.fetch(request)
                if let restaurantMO = restaurantResult.first as? RestaurantMO {
                    context.delete(restaurantMO)
                    try context.save()
                    completion(true)
                }
            } catch {
                completion(false)
                print ("Error in deleteRestaurant method")
            }
        }
    }

    func searchRestaurant (restaurantName: String, completion: @escaping ([Restaurant]) -> Void) {
        DispatchQueue.global(qos: .background).async {
            var restaurantList = [Restaurant]()
            let context = self.persistentContainer.newBackgroundContext()
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RestaurantMO")
            let predicateName = NSPredicate(format: "name CONTAINS[c] %@ ", restaurantName)
            let predicateLocation = NSPredicate(format: "location CONTAINS[c] %@ ", restaurantName)
            let predicate = NSCompoundPredicate (orPredicateWithSubpredicates: [predicateName, predicateLocation])

            request.predicate = predicate

            context.performAndWait {
                do {
                    let results = try context.fetch(request) as! [RestaurantMO]
                    results.forEach({ restaurantList.append(Restaurant(restaurant: $0)) })
                } catch {
                    print ("Error in search method")
                }
            }
            DispatchQueue.main.async {
                completion(restaurantList)
            }
        }
    }
}

extension Database: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.willChangeContent()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any,
                    at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                delegate?.didInsert(indexPath: newIndexPath)
            }
        case .delete:
            if let indexPath = indexPath {
                delegate?.didDelete(indexPath: indexPath)
            }
        case .update:
            if let indexPath = indexPath {
                delegate?.didUpdate(indexPath: indexPath)
            }
        default:
            break
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didChangeContent()
    }
}
