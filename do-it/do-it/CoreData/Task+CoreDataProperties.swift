//
//  Task+CoreDataProperties.swift
//  do-it
//
//  Created by Deyan Aleksandrov on 31.12.17.
//  Copyright © 2017 dido. All rights reserved.
//
//

import UIKit
import CoreData


extension Task {

//    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
//        return NSFetchRequest<Task>(entityName: "Task")
//    }

    @NSManaged public var categoryColor: String?
    @NSManaged public var categoryName: String?
    @NSManaged public var completionDate: Date?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var title: String?

    static let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
    static let maxLimitCount = 1000

    // MARK: - Get Managed Context
    static func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let coordinator = appDelegate.persistentContainer.persistentStoreCoordinator
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }

    static func loadTasks() -> [Task] {
        let managedContext = getContext()

        do {
            return try managedContext.fetch(request) as? [Task] ?? [Task]()
        } catch let error as NSError {
            print("Core Data: Could not fetch context \(error), \(error.userInfo)")
        }
        return []
    }

    static func loadTask(position: Int) -> Task {
        return loadTasks()[position]
    }

    static func saveTask(title: String, categoryName: String, categoryColor: String, completionDate: Date, isCompleted: Bool) {
        let tasks = loadTasks()
        let managedContext = getContext()

        if let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext) {
            let task = NSManagedObject(entity: entity, insertInto: managedContext)

            task.setValue(title, forKey: "title")
            task.setValue(categoryName, forKey: "categoryName")
            task.setValue(categoryColor, forKey: "categoryColor")
            task.setValue(completionDate, forKey: "completionDate")
            task.setValue(isCompleted, forKey: "isCompleted")

            do {
                try managedContext.save()
            } catch let error {
                print("Could not save with \(error)")
            }


            if tasks.count >= maxLimitCount {
                do {
                    let results = try managedContext.fetch(request)
                    managedContext.delete(results.first as! NSManagedObject)
                    do {
                        try managedContext.save()
                    } catch let error {
                        print("Could not save context \(error)")
                    }
                } catch let error {
                    print("Save task in core data error: \(error)")
                }
            }
        }
    }

    static func deleteTask(title: String, completion: @escaping ()->()) {
        let managedContext = getContext()

        do {
            let results = try managedContext.fetch(request)
            let managedObjectData = results.filter({ ($0 as AnyObject).title == title }).first as! NSManagedObject
            managedContext.delete(managedObjectData)
            do {
                try managedContext.save()
                completion()
            } catch let error as NSError  {
                print("Could not save context \(error), \(error.userInfo)")
            }
        } catch let error as NSError {
            print("Delete task in core data error : \(error) \(error.userInfo)")
        }
    }

    static func markAsCompleted(title: String, completion: @escaping ()->()) {
        let managedContext = getContext()

        do {
            let results = try managedContext.fetch(request)
            let object = results.filter({ ($0 as AnyObject).title == title }).first as! Task
            object.setValue(true, forKey: "isCompleted")
            do {
                try managedContext.save()
                completion()
            } catch let error as NSError  {
                print("Could not save context \(error), \(error.userInfo)")
            }
        } catch let error as NSError {
            print("Could not fetch data in core data error : \(error) \(error.userInfo)")
        }
    }

}
