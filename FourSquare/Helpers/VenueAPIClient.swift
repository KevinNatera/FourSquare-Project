//
//  VenueAPIClient.swift
//  FourSquare
//
//  Created by Kevin Natera on 11/13/19.
//  Copyright © 2019 Kevin Natera. All rights reserved.
//

import Foundation


class VenueAPIClient {
    private init() {}
    
    static let shared = VenueAPIClient()
    
    func getVenues(lat: Double, long: Double, query: String?, completionHandler: @escaping (Result<[Venue],AppError>) -> () ) {

        let urlStr = "https://api.foursquare.com/v2/venues/search?ll=\(lat),\(long)&client_id=\(Secrets.apiID)&client_secret=\(Secrets.apiKey)&v=20191104&query=\(query ?? "coffee")"
        
        guard let url = URL(string: urlStr) else {
            completionHandler(.failure(.badURL))
            return
        }
        
        NetworkHelper.manager.performDataTask(withUrl: url, andMethod: .get) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(VenueResponse.self, from: data)
                    completionHandler(.success(response.response.venues))
                } catch {
                    completionHandler(.failure(.couldNotParseJSON(rawError: error)))
                }
            }
        }
    }
}
