//
//  VenueCollectionViewCell.swift
//  FourSquare
//
//  Created by Kevin Natera on 11/14/19.
//  Copyright © 2019 Kevin Natera. All rights reserved.
//

import UIKit

class VenueCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var venueImageOutlet: UIImageView!
    
    
    func configureCell(venue: Venue) {
        VenueAPIClient.shared.getImages(id: venue.id) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                    self.venueImageOutlet.image = UIImage(named: "noImage")
                case .success(let imageData):
                    ImageHelper.shared.getImage(urlStr: imageData.first?.imageInfo ?? "") { (result) in
                        DispatchQueue.main.async {
                            switch result {
                            case .failure(let error):
                                print(error)
                                self.venueImageOutlet.image = UIImage(named: "noImage")
                            case .success(let image):
                                self.venueImageOutlet.image = image
                            }
                        }
                    }
                }
            }
        }
    }
}
