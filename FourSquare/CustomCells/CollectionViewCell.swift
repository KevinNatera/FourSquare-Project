//
//  CollectionViewCell.swift
//  FourSquare
//
//  Created by Kevin Natera on 11/16/19.
//  Copyright © 2019 Kevin Natera. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var venueImageOutlet: UIImageView!
    
    func configureCell(collection: Collections) {
        titleLabel.text = collection.title
        VenueAPIClient.shared.getImages(id: collection.venues.first?.id ?? "") { (result) in
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
