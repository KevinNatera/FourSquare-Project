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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return cell
    }
    
    
}

