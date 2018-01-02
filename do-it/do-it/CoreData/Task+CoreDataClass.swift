//
//  Task+CoreDataClass.swift
//  do-it
//
//  Created by Deyan Aleksandrov on 31.12.17.
//  Copyright © 2017 dido. All rights reserved.
//
//

import UIKit
import CoreData

public class Task: NSManagedObject {

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

    static func loadTask(by title: String) -> Task? {
        if let indexToReturn = loadTasks().index(where: { $0.title == title }) {
            return loadTasks()[indexToReturn]
        }
        return nil
    }

    static func saveTask(title: String, categoryName: String, categoryColor: String, completionDate: Date, isCompleted: Bool, completion: @escaping ()->()) {
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
                completion()
            } catch let error {
                print("Could not save with \(error)")
            }


            if tasks.count >= maxLimitCount {
                do {
                    let results = try managedContext.fetch(request)
                    if let firstResult = results.first as? NSManagedObject {
                        managedContext.delete(firstResult)
                    }
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

            guard let objectToDelete = results.filter({ ($0 as AnyObject).title == title }).first as? NSManagedObject else {
                Validator.addOkAllert("Failed at deleting task. Please try again!")
                return
            }
            managedContext.delete(objectToDelete)
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

    static func editTask(title: String, categoryName: String, categoryColor: String, completionDate: Date, isCompleted: Bool, completion: @escaping ()->()) {
        let managedContext = getContext()

        do {
            let results = try managedContext.fetch(request)
            guard let task = results.filter({ ($0 as AnyObject).title == title }).first as? Task else {
                Validator.addOkAllert("Failed at editing task. Please try again!")
                return
            }

            task.setValue(categoryName, forKey: "categoryName")
            task.setValue(categoryColor, forKey: "categoryColor")
            task.setValue(completionDate, forKey: "completionDate")
            task.setValue(isCompleted, forKey: "isCompleted")
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
