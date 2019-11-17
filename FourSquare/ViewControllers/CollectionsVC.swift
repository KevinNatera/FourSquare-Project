//
//  CollectionsVC.swift
//  FourSquare
//
//  Created by Kevin Natera on 11/13/19.
//  Copyright © 2019 Kevin Natera. All rights reserved.
//

import UIKit

class CollectionsVC: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var collectionsOutlet: UICollectionView!
    @IBOutlet weak var collectionTitleTextField: UITextField!
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        collectionTitleTextField.alpha = 1
        collectionsOutlet.alpha = 0
    }
    
    var collections = [Collections]() {
        didSet {
            collectionsOutlet.reloadData()
        }
    }
    
    var venue: Venue! {
        didSet {
            print(venue)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUp()
        loadData()
    }
    
    //MARK: - Private Methods
    
    private func loadData() {
        collections = try! CollectionsPersistenceHelper.manager.getCollections()
    }
    
    private func setUp() {
        collectionsOutlet.delegate = self
        collectionsOutlet.dataSource = self
        collectionTitleTextField.delegate = self
        collectionTitleTextField.alpha = 0
    }
    
}
//MARK: - Extensions

extension CollectionsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionsOutlet.dequeueReusableCell(withReuseIdentifier: "collections", for: indexPath) as! CollectionViewCell
        let collection = collections[indexPath.row]
        cell.configureCell(collection: collection)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let newVenue = venue {
            var newCollection = collections
            newCollection[indexPath.row].venues.append(newVenue)
            try? CollectionsPersistenceHelper.manager.edit(newCollectionsArray: newCollection)
            let alert = UIAlertController(title: "Saved!", message: "Venue successfully added to collection.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(cancelAction)
            present(alert, animated: true)
            print(newCollection[indexPath.row].venues)
        }
        
    }
}

extension CollectionsVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != "" && textField.text != nil {
            let newCollection = Collections(title: textField.text!, venues: [])
            try? CollectionsPersistenceHelper.manager.save(newCollection: newCollection)
            collectionTitleTextField.alpha = 0
            collectionsOutlet.alpha = 1
            loadData()
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        collectionsOutlet.reloadData()
    }
    
}
