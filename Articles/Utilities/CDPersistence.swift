//
//  CDPersistence.swift
//  Articles
//
//  Created by Anna on 8/16/18.
//  Copyright © 2018 Anna. All rights reserved.
//

import UIKit
import CoreData

class CDPersistence {
    
    static func save(article: Article, index: Int) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Record", in: managedContext)!
        let record = NSManagedObject(entity: entity, insertInto: managedContext)
        
        record.setValue(index, forKeyPath: "indexNumber")
        record.setValue(article.id, forKeyPath: "id")
        record.setValue(article.imageMediumPath, forKeyPath: "imageMediumPath")
        record.setValue(article.imageThumbPath, forKeyPath: "imageThumbPath")
        record.setValue(article.title, forKeyPath: "title")
        record.setValue(article.urlPath, forKeyPath: "urlPath")
        
        if let image = UIDevice.current.iPad() ? article.imageMedium() : article.imageThumb() {
            Cache.cacheImage(image, key: article.title)
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
     static func fetchRecords() -> [NSManagedObject] {
        var records = [NSManagedObject]()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return records }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Record")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "indexNumber", ascending: true)]
        
        do {
            records = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return records
    }
    
    static func resetAllRecords() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Record")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
        }
        catch {
            print(error)
        }
    }
    
    static func updateRecord(index: Int, title: String) {
        var records = [NSManagedObject]()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Record")
        fetchRequest.predicate = NSPredicate(format: "title = %@", title)
        
        do {
            records = try managedContext.fetch(fetchRequest)
            if let updatedObject = records.first {
                updatedObject.setValue(index, forKey: "indexNumber")
                try managedContext.save()
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
