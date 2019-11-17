//
//  VenuePersistenceHelper.swift
//  FourSquare
//
//  Created by Kevin Natera on 11/15/19.
//  Copyright © 2019 Kevin Natera. All rights reserved.
//

import Foundation


struct CollectionsPersistenceHelper {
    static let manager = CollectionsPersistenceHelper()
    
    func getCollections() throws -> [Collections] {
        return try persistenceHelper.getObjects()
    }
    
    func save(newCollection: Collections) throws {
        try persistenceHelper.save(newElement: newCollection)
    }
    
    func edit(newCollectionsArray: [Collections]) throws {
        try persistenceHelper.replace(elements: newCollectionsArray)
    }
    
    private let persistenceHelper = PersistenceHelper<Collections>(fileName: "collections.plist")
    
    private init() {}
}



