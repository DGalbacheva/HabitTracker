//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Doroteya Galbacheva on 05.11.2024.
//

import UIKit
import CoreData

final class TrackerRecordStore {
    private let context: NSManagedObjectContext
    
    convenience init() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    private func fetchRequest() -> NSFetchRequest<TrackerRecordCD> {
        return NSFetchRequest<TrackerRecordCD>(entityName: "TrackerRecordCD")
    }
    
    func addTrackerRecord(trackerId: UUID, date: Date) throws {
        let trackerRecord = TrackerRecordCD(context: context)
        trackerRecord.trackerId = trackerId
        trackerRecord.date = Calendar.current.startOfDay(for: date)
        try context.save()
    }
    
    func removeTrackerRecord(trackerId: UUID, date: Date) {
        let fetchRequest = fetchRequest()
        let startOfDay = Calendar.current.startOfDay(for: date)
        
        fetchRequest.predicate = NSPredicate(format: "trackerId == %@ AND date == %@", trackerId as CVarArg, startOfDay as NSDate)
        
        do {
            let records = try context.fetch(fetchRequest)
            for record in records {
                context.delete(record)
            }
            try context.save()
        } catch {
            print("Failed to delete tracker entry: \(error)")
        }
    }
    
    func getTrackerRecords(by trackerId: UUID) -> [TrackerRecord] {
        let fetchRequest = fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "trackerId == %@", trackerId as CVarArg)
        var trackerRecords: [TrackerRecord] = []
        var trackerRecordsCD: [TrackerRecordCD] = []
        do {
            trackerRecordsCD = try context.fetch(fetchRequest)
            for category in trackerRecordsCD {
                if let recordID = category.trackerId, let recordDate = category.date {
                    trackerRecords.append(TrackerRecord(trackerId: recordID, date: recordDate))
                }
            }
            return trackerRecords
        } catch {
            print("Failed to get TrackerRecordCD records: \(error)")
            return []
        }
    }
    
    func isTrackerCompleted(trackerId: UUID, date: Date) -> Bool {
        let fetchRequest = fetchRequest()
        let startOfDay = Calendar.current.startOfDay(for: date)
        
        fetchRequest.predicate = NSPredicate(format: "trackerId == %@ AND date == %@", trackerId as CVarArg, startOfDay as NSDate)
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Failed to verify tracker completion: \(error)")
            return false
        }
    }
    
    func removeAllTrackerRecords() {
        let fetchRequest = fetchRequest()
        var trackerRecordCD: [TrackerRecordCD] = []
        do {
            trackerRecordCD = try context.fetch(fetchRequest)
        } catch {
            print("There are no records of completed trackers in the database")
        }
        for i in trackerRecordCD {
            context.delete(i)
        }
        
        do {
            try context.save()
        } catch {
            print("Failed to delete all completed tracker records")
        }
    }
    
    func getAllTrackerRecords() -> [TrackerRecord] {
        let fetchRequest = fetchRequest()
        var trackerRecords: [TrackerRecord] = []
        var trackerRecordsCD: [TrackerRecordCD] = []
        do {
            trackerRecordsCD = try context.fetch(fetchRequest)
            for i in trackerRecordsCD {
                if let recordID = i.trackerId, let recordDate = i.date {
                    trackerRecords.append(TrackerRecord(trackerId: recordID, date: recordDate))
                }
            }
            return trackerRecords
        } catch {
            print("Failed to get TrackerRecordCD records: \(error)")
            return []
        }
    }
}

