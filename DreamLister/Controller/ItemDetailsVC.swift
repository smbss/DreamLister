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
    
    var stores = [Store]()
    var imagePicker: UIImagePickerController!
    
        // Optional var that will pass the item that is being edited
    var itemToEdit: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            // Removing the back button title in the nav bar
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
        
            // Populating the store picker on the first launch
        let detectFirstLaunch = isFirstLaunch()
        if detectFirstLaunch {
            createStores()
        }
        
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
    
    func getStores() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        do {
            self.stores = try context.fetch(fetchRequest)
                // Reloading all the components inside the StorePicker after the fetch
            self.storePicker.reloadAllComponents()
        } catch {
            print("Error loading stores")
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
        
            // Saving the relationship to the image
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
            
                // Updating the pickerView to the correct store
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
        createStore(storeName: "Best Buy")
        createStore(storeName: "Tesla Dealership")
        createStore(storeName: "Frys Electronics")
        createStore(storeName: "Amazon")
        createStore(storeName: "Target")
        createStore(storeName: "K Mart")
        
            // Saving it to CoreData
        ad.saveContext()
    }
    
    func createStore(storeName: String) {
        let store = Store(context: context)
        store.name = storeName
    }
    
    func isFirstLaunch() -> Bool {
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "isItemDetailsVCFirstLaunch") != nil {
            return false
        } else {
            defaults.set(false, forKey: "isItemDetailsVCFirstLaunch")
            defaults.synchronize()
            return true
        }
    }
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        
            // Checking if an existing item is being edited
        if itemToEdit != nil {
                // Deleting the existing item from CoreData
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
    
        // Making the return key work
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleField.resignFirstResponder()
        priceField.resignFirstResponder()
        detailsField.resignFirstResponder()
        return true
    }
    
}
