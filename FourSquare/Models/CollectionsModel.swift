//
//  CollectionsModel.swift
//  FourSquare
//
//  Created by Kevin Natera on 11/16/19.
//  Copyright © 2019 Kevin Natera. All rights reserved.
//

import Foundation

struct Collections: Codable {
    var title: String
    var venues: [Venue]
}
