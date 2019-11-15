//
//  VenueModel.swift
//  FourSquare
//
//  Created by Kevin Natera on 11/13/19.
//  Copyright © 2019 Kevin Natera. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

struct VenueResponse: Codable {
    let response: VenueWrapper
}
struct VenueWrapper: Codable {
    let venues: [Venue]
}

class Venue: NSObject, Codable, MKAnnotation {
    let id: String
    let name: String
    let location: LocationWrapper
    
    @objc var coordinate: CLLocationCoordinate2D {
        let latLong = [location.lat, location.lng]
        return CLLocationCoordinate2D(latitude: latLong[0], longitude: latLong[1])
    }
    
    var hasValidCoordinates: Bool {
        return coordinate.latitude != 0 && coordinate.longitude != 0
    }
    
    static func getVenues(from data: Data) throws -> [Venue]? {
        do {
            let response = try JSONDecoder().decode(VenueResponse.self,from: data)
            return response.response.venues
        } catch {
            return nil
        }
    }
}

struct LocationWrapper: Codable {
    let address: String?
    let lat: Double
    let lng: Double
}
