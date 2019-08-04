//
//  ArchiveUtil.swift
//  Bilhete Unico
//
//  Created by Matheus Pedrosa on 8/4/19.
//  Copyright © 2019 M2P. All rights reserved.
//

import Foundation

class ArchiveUtil {
    private static let tripsKey = "TripsKey"
    
    private static func archiveTrips(trips: [Trip]) -> NSData {
        return NSKeyedArchiver.archivedData(withRootObject: trips) as NSData
    }
    
    static func loadTrips() -> [Trip]? {
        if let unarchiveObject = UserDefaults.standard.object(forKey: tripsKey) as? NSData {
            return NSKeyedUnarchiver.unarchiveObject(with: unarchiveObject as Data) as? [Trip]
        }
        return nil
    }
    
    static func saveTrips(trips: [Trip]?) {
        let archievedObject = archiveTrips(trips: trips!)
        UserDefaults.standard.set(archievedObject, forKey: tripsKey)
        UserDefaults.standard.synchronize()
    }
}
