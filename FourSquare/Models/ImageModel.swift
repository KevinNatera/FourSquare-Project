//
//  ImageModel.swift
//  FourSquare
//
//  Created by Kevin Natera on 11/14/19.
//  Copyright © 2019 Kevin Natera. All rights reserved.
//

import Foundation

struct ImageResponse: Codable {
    let response: ImageWrapper
}

struct ImageWrapper: Codable {
    let photos: Items
}

struct Items: Codable {
    let items: [Photo]
}

struct Photo: Codable {
    let prefix: String
    let suffix: String
    var imageInfo: String {
        return "\(prefix)original\(suffix)"
    }
}
