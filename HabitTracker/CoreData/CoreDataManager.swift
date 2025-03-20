//
//  CoreDataManager.swift
//  Tracker
//
//  Created by Doroteya Galbacheva on 05.11.2024.
//

import UIKit
import CoreData

protocol CoreDataManagerDelegate: AnyObject {
    func didChangeData(_ data: [TrackerCategory])
}

final class CoreDataManager: NSObject {
    
    static let shared = CoreDataManager()
    private override init() {}
    
    lazy var trackerStore = TrackerStore()
    lazy var trackerCategoryStore = TrackerCategoryStore()
    lazy var trackerRecordStore = TrackerRecordStore()
    lazy var uiColorMarshalling = UIColorMarshalling()
    weak var delegate: CoreDataManagerDelegate?
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackerCoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print(error.localizedDescription)
                assertionFailure("Unresolved error \(error), \(error.userInfo)")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    private var context: NSManagedObjectContext { persistentContainer.viewContext }
    private var fetchedResultsController: NSFetchedResultsController<TrackerCD>!
    
    func configureFetchedResultsController(for weekday: String) {
        let fetchRequest = NSFetchRequest<TrackerCD>(entityName: "TrackerCD")
        fetchRequest.predicate = NSPredicate(format: "schedule CONTAINS %@", weekday)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "category.title", ascending: true)]
        // Если FRC ещё не был инициализирован, создаем его
        if fetchedResultsController == nil {
            print("FRC nil")
            fetchedResultsController = NSFetchedResultsController(
                fetchRequest: fetchRequest,
                managedObjectContext: context,
                sectionNameKeyPath: "category.title",
                cacheName: nil
            )
            fetchedResultsController.delegate = self
        } else {
            print("FRC not nil")
            fetchedResultsController.fetchRequest.predicate = fetchRequest.predicate
        }
        
        do {
            try fetchedResultsController.performFetch()
            print("Loading Trackers")
            if let fetchedObjects = fetchedResultsController.fetchedObjects {
                let trackerCategories = convertToTrackerCategories(fetchedObjects)
                delegate?.didChangeData(trackerCategories)
            }
        } catch {
            print("Request execution error: \(error)")
        }
        
    }
    
    private func createTracker(from trackerCD: TrackerCD) -> Tracker? {
        guard let trackerID = trackerCD.id,
              let trackerTitle = trackerCD.title,
              let trackerColorString = trackerCD.color,
              let trackerScheduleString = trackerCD.schedule,
              let trackerEmoji = trackerCD.emoji
        else {
            return nil
        }
        
        let trackerColor = uiColorMarshalling.color(from: trackerColorString)
        let trackerSchedule = trackerScheduleString.toWeekdaysArray()
        
        let tracker = Tracker(id: trackerID, title: trackerTitle, color: trackerColor, emoji: trackerEmoji, schedule: trackerSchedule)
        return tracker
    }
    
    private func convertToTrackerCategories(_ trackerCDs: [TrackerCD]) -> [TrackerCategory] {
        var trackerCategories: [TrackerCategory] = []
        for trackerCD in trackerCDs {
            if let tracker = createTracker(from: trackerCD) {
                if let categoryIndex = trackerCategories.firstIndex(where: { $0.title == trackerCD.category?.title }) {
                    let existingCategory = trackerCategories[categoryIndex]
                    let updatedTrackers = existingCategory.trackers + [tracker]
                    let updatedCategory = TrackerCategory(title: existingCategory.title, trackers: updatedTrackers)
                    trackerCategories[categoryIndex] = updatedCategory
                } else {
                    let newCategory = TrackerCategory(title: trackerCD.category?.title ?? "Без категории", trackers: [tracker])
                    trackerCategories.append(newCategory)
                }
            }
        }
        return trackerCategories
    }
}

extension CoreDataManager: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        print("Will change content")
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        print("Volunteered DidChangeContent")
        
        if let fetchedObjects = fetchedResultsController.fetchedObjects {
            let trackerCategories = convertToTrackerCategories(fetchedObjects)
            delegate?.didChangeData(trackerCategories)
        } else {
            print("Failed to obtain requested objects")
        }
    }
    
    internal func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        print("Did change object")
    }
}

