//
//  MainVC.swift
//  DreamLister
//
//  Created by smbss on 14/09/16.
//  Copyright © 2016 smbss. All rights reserved.
//

import UIKit
import CoreData

// Since we are going to work with CoreData we have to use NSFetchedResultsControllerDelegate
class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    // FRC efficiently imports the needed values to populate i.e a table while it doesn't need to import all the other ones
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    // Setting the FRC to fetch the Item entity
    var controller: NSFetchedResultsController<Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //generateTestData()
        attemptFetch()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: ItemCell, indexPath: IndexPath) {
        
        let item = controller.object(at: indexPath)
        cell.configureCell(item: item)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Preparing the object that will be sent to the next view
        if let objs = controller.fetchedObjects, objs.count > 0 {
            
            let item = objs[indexPath.row]
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
        }
    }
    
    // Preparing the connection of data between the two views
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetailsVC" {
            if let destination = segue.destination as? ItemDetailsVC {
                if let item = sender as? Item {
                    destination.itemToEdit = item
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Grabbing the section data from the controller
        if let sections = controller.sections {
            
            // We want to have as many rows in the section as there are objects
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        // If there are no sections just return 0
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = controller.sections {
            return sections.count
        }
        
        return 0
    }
    
    // Setting the high for the cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func attemptFetch() {
        
        // Creating the var that will save the request and telling it what to go fetch
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        // Creating the vars that will sort the data
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        
        // Ordering the fetch request depending on the selected segment
        if segment.selectedSegmentIndex == 0 {
            fetchRequest.sortDescriptors = [dateSort]
        } else if segment.selectedSegmentIndex == 1 {
            fetchRequest.sortDescriptors = [priceSort]
        } else if segment.selectedSegmentIndex == 2 {
            fetchRequest.sortDescriptors = [titleSort]
        }
        
        // Instantiating our FRC
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        // The ManagedObjectContext is handled over in the AppDelegate on the PersistanceContainer
        // Instead of going to look the code on the AppDelegate every time we are going to create a shortcut in the AppDelegate.swift file
        // Shortcuts on the AppDelegate: "ad" and "context"
        
        // sectionNameKeyPath is not needed because we just want to return all of the results
        // We don't need to name the cache
        
        // Telling the controller what to listen to
        controller.delegate = self
        
        // Setting the outside controller to be the same as the inside one
        self.controller = controller
        
        // Trying to do the fetch request
        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
        
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        
        attemptFetch()
        tableView.reloadData()
    }
    
    
    // This method notifies when the content is about to be changed
    // When the TableView is about to update it will listen for changes and update the views
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.beginUpdates()
    }
    
    // This method notifies when the content finished being changed
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.endUpdates()
    }
    
    // Notifies when the fetched object has been changed
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        // cmd+click on NSFetchedResultsChangeType to see which cases we have to implement
        // Below we are going to be using the newIndexPath and the type arguments from this method
        
        switch(type) {
            
        // Making the new item appear on the table view by fading in
        case.insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
            
        // Getting the existing indexPath and deleting it
        case.delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
            
        // Updating the cell data for a certain indexPath
        case.update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                configureCell(cell: cell, indexPath: indexPath)
            }
            break
            
            // Updating the indexPath for a item that has been moved in the tableView
        // You can insert multipkle cells at the same time using the array on the first arg
        case.move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
            
        }
    }
    
    func generateTestData() {
        let item = Item(context: context)
        item.title = "MacBook Pro"
        item.price = 1800
        item.details = "I can't wait until this September event, I hope they release new MBPs"
        
        let item2 = Item(context: context)
        item2.title = "Bose Headphones"
        item2.price = 300
        item2.details = "But man, noise canceling is so good"
        
        let item3 = Item(context: context)
        item3.title = "Tesla Model S"
        item3.price = 110000
        item3.details = "The car of the future"
        
        // Permanently saving it in CoreData
        ad.saveContext()
    }
    
}
