//
//  VenueTableViewCell.swift
//  FourSquare
//
//  Created by Kevin Natera on 11/14/19.
//  Copyright © 2019 Kevin Natera. All rights reserved.
//

import UIKit

class VenueTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var venueImageOutlet: UIImageView!
    @IBOutlet weak var venueNameLabel: UILabel!
    @IBOutlet weak var venueAddressLabel: UILabel!
    
    
    func configureCell(venue: Venue) {
        venueNameLabel.text = venue.name
        venueAddressLabel.text = venue.location.address
        
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
