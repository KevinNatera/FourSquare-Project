//
//  ListVC.swift
//  FourSquare
//
//  Created by Kevin Natera on 11/14/19.
//  Copyright © 2019 Kevin Natera. All rights reserved.
//

import UIKit

class ListVC: UIViewController {

    @IBOutlet weak var resultsTableOutlet: UITableView!
    
    var venueList: [Venue]!
    
  
    
    
    override func viewWillAppear(_ animated: Bool) {
        setUp()
    }
    
    private func setUp() {
        resultsTableOutlet.delegate = self
        resultsTableOutlet.dataSource = self
        resultsTableOutlet.rowHeight = 150
    }

}

extension ListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venueList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultsTableOutlet.dequeueReusableCell(withIdentifier: "venues") as! VenueTableViewCell
        let venue = venueList[indexPath.row]
        cell.configureCell(venue: venue)
        cell.favoriteButton.tag = indexPath.row
        cell.favoriteButton.venue = venue
        cell.delegate = self
        return cell
    }
    
    
}

extension ListVC: AddButtonDelegate {
    
    func segue(sender: AddButton) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let navVC = storyBoard.instantiateViewController(identifier: "navVC1") as! UINavigationController
        let collectionVC = navVC.topViewController as! CollectionsVC
        present(navVC, animated: true)
        navVC.title = "Choose a collection"
        collectionVC.venue = sender.venue
    }
    
    
}
