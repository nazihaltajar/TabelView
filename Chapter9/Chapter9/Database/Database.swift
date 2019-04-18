//
//  Database.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 16/04/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import Foundation
import CoreData
class Database {
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

    func saveRestaurant(restaurant: Restaurant) {
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

            try? context.save()
        }
    }

    func updateRestaurant(restaurant: Restaurant) {
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
                    try? context.save()
                }
            } catch {
                print ("Error fetching data from context \(error)")
            }
        }
        return
    }

    func deleteRestaurant(restaurant: Restaurant) {
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
                }
            } catch {
                print ("Error in deleteRestaurant method")
            }
        }
    }

    func searchRestaurant (restaurantName: String) -> [Restaurant] {
        var restaurantList = [Restaurant]()
        let context = persistentContainer.newBackgroundContext()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RestaurantMO")
        let predicateName = NSPredicate(format: "name CONTAINS[c] %@ ", restaurantName)
        let predicateLocation = NSPredicate(format: "location CONTAINS[c] %@ ", restaurantName)
        let predicate = NSCompoundPredicate (orPredicateWithSubpredicates: [predicateName, predicateLocation])

        request.predicate = predicate

        context.performAndWait {
            do {
                let result = try context.fetch(request) as! [RestaurantMO]

                for restaurantF in result {
                    let restaurant = Restaurant(restaurant: restaurantF)
                    restaurantList.append(restaurant)
                }
            } catch {
                print ("Error in search method")
            }
        }
        return restaurantList
    }

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
