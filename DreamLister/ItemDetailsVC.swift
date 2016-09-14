//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by smbss on 14/09/16.
//  Copyright © 2016 smbss. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    
    @IBOutlet weak var thumbImg: UIImageView!
    
    // Creating the array of Stores
    var stores = [Store]()
    // Creating an optional var that will pass the item we need to edit
    var itemToEdit: Item?
    // Creating the var for the image picker controller
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Replacing the Navigation Bar title with an empty one so it doesn't appear every time we want to go back to the main one
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        titleField.delegate = self
        priceField.delegate = self
        detailsField.delegate = self
        
        //createStores()
        getStores()
        
        // Checking if we are editing or adding a new item
        if itemToEdit != nil {
            loadItemData()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let store = stores[row]
        return store.name
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return stores.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // update when selected
    }
    
    func getStores() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        do {
            self.stores = try context.fetch(fetchRequest)
            // Reloading all the components inside the StorePicker after the fetch
            self.storePicker.reloadAllComponents()
        } catch {
            // Handle the error
        }
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        var item : Item!
        
        // Creating a new Image entity inside NSManaged object
        let picture = Image(context: context)
        // Saving the image into that entity
        picture.image = thumbImg.image
        
        // Check: New or existing item?
        if itemToEdit == nil {
            // Creating an entity into the NSManageObject context
            item = Item(context: context)
        } else {
            // Loading the existing one
            item = itemToEdit
        }
        
        // Saving the relationship and presenting the image
        item.toImage = picture
        
        if let title = titleField.text {
            item.title = title
        }
        
        if let price = priceField.text {
            // Converting the price to an NSString so we can get more properties like doubleValue
            item.price = (price as NSString).doubleValue
        }
        
        if let details = detailsField.text {
            item.details = details
        }
        
        // Saving the store in the item
        // We need to use the relationship name after item.
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        // [!] Components are the columns
        
        ad.saveContext()
        // Dismissing the current view
        _ = navigationController?.popViewController(animated: true)
    }
    
    func loadItemData() {
        
        if let item = itemToEdit {
            titleField.text = item.title
            priceField.text = String(item.price)
            detailsField.text = item.details
            // Casting the image as an UIImage because it is an NSObject
            thumbImg.image = item.toImage?.image as? UIImage
            
            // Setting the picker to the correct store if the item has a store
            if let store = item.toStore {
                var index = 0
                repeat {
                    let s = stores[index]
                    if s.name == store.name {
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                } while (index < stores.count)
            }
        }
        
    }
    
    func createStores() {
        // Creating the store data
        let store = Store(context: context)
        store.name = "Best Buy"
        let store2 = Store(context: context)
        store2.name = "Tesla Dealership"
        let store3 = Store(context: context)
        store3.name = "Frys Electronics"
        let store4 = Store(context: context)
        store4.name = "Amazon"
        let store5 = Store(context: context)
        store5.name = "Target"
        let store6 = Store(context: context)
        store6.name = "K Mart"
        // Saving it to CoreData
        ad.saveContext()
    }
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        
        // Checking if this view is presenting an existing item
        if itemToEdit != nil {
            // Deleting the item and saving CoreData
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        // Going back to the previous view
        _ = navigationController?.popViewController(animated: true)
    }
    
    // Presenting the imagePickerController once the image button is pressed
    @IBAction func addImage(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Func that will populate the image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            thumbImg.image = img
        }
        // Making it disapear after selecting
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleField.resignFirstResponder()
        priceField.resignFirstResponder()
        detailsField.resignFirstResponder()
        return true
    }
    
}
