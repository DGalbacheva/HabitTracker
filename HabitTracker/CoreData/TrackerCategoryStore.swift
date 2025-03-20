//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Doroteya Galbacheva on 05.11.2024.
//

import UIKit
import CoreData

final class TrackerCategoryStore {
    private let context: NSManagedObjectContext
    private let trackerStore = TrackerStore()
    private let uiColorMarshalling = UIColorMarshalling()
    convenience init() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    private func fetchRequest() -> NSFetchRequest<TrackerCategoryCD> {
        return NSFetchRequest<TrackerCategoryCD>(entityName: "TrackerCategoryCD")
    }
    
    
    func removeAllTrackerCategory() {
        let request = fetchRequest()
        var trackerCategoryFromDB: [TrackerCategoryCD] = []
        do {
            trackerCategoryFromDB = try context.fetch(request)
        }  catch {
            print("There are no trackers in the database")
            return
        }
        for i in trackerCategoryFromDB {
            context.delete(i)
        }
        
        do {
            try context.save()
        } catch {
            print("Failed to delete all completed tracker records")
        }
    }
    
    func getTrackerCategoryFromDB() -> [TrackerCategory] {
        var trackerCategoryesArray: [TrackerCategory] = []
        let request = fetchRequest()
        var trackerCategoryesFromDB: [TrackerCategoryCD] = []
        do {
            trackerCategoryesFromDB = try context.fetch(request)
        }  catch {
            print("There is no TrackerCategoryCD in the database")
            return []
        }
        for i in trackerCategoryesFromDB {
            if let newTrackerCategory = createTrackerCategory(from: i) {
                trackerCategoryesArray.append(newTrackerCategory)
            } else {
                print("Failed to create categories from TrackerCategoryCD")
            }
        }
        return trackerCategoryesArray
    }
    
    private func createTrackerCategory(from category: TrackerCategoryCD) -> TrackerCategory? {
        guard let title = category.title,
              let trackersCD = (category.trackers as? Set<TrackerCD>)
        else {return nil}
        var trackers: [Tracker] = []
        for i in trackersCD {
            if let trecker = createTracker(from: i) {
                trackers.append(trecker)
            }
        }
        let trackerCategoty = TrackerCategory(title: title, trackers: trackers)
        return trackerCategoty
    }
    
    func getTrackersForWeekday(_ weekday: String) -> [TrackerCategory] {
        let fetchRequest: NSFetchRequest<TrackerCD> = TrackerCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "schedule CONTAINS %@", weekday)
        
        var trackersFromDB: [TrackerCD] = []
        do {
            trackersFromDB = try context.fetch(fetchRequest)
        } catch {
            print("Error loading trackers for day of week \(weekday): \(error)")
            return []
        }
        
        var trackerCategories: [TrackerCategory] = []
        for trackerCD in trackersFromDB {
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
    
    func saveNewCategory(title: String) {
        let category = TrackerCategoryCD(context: context)
        category.title = title
        do {
            try context.save()
        } catch {
            print("Failed to save new category")
        }
    }
}

