//
//  ImageAPIClient.swift
//  FourSquare
//
//  Created by Kevin Natera on 11/14/19.
//  Copyright © 2019 Kevin Natera. All rights reserved.
//

import Foundation

class ImageAPIClient {
    
    static let manager = ImageAPIClient()
    
    func getImages(id: String, completionHandler: @escaping (Result<[Photo], AppError>) -> ()) {
        let urlString = "https://api.foursquare.com/v2/venues/\(id)/photos?client_id=\(Secrets.apiID)&client_secret=\(Secrets.apiKey)&v=20191104&limit=1"
        print(urlString)
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.badURL))
            return
        }
        NetworkHelper.manager.performDataTask(withUrl: url , andMethod: .get) { (result) in
            switch result {
            case .failure(let error) :
                completionHandler(.failure(error))
            case .success(let data):
                do {
                    let imageInfo = try JSONDecoder().decode(ImageResponse.self, from: data)
                    
                    completionHandler(.success(imageInfo.response.photos.items))
                } catch {
                    print(error)
                    completionHandler(.failure(.other(rawError: error)))
                }
            }
        }
        
        
    }
    
}
