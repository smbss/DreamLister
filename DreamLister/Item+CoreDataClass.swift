//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Sandro Simes on 14/09/16.
//  Copyright © 2016 smbss. All rights reserved.
//

import Foundation
import CoreData


public class Item: NSManagedObject {
    // Setting the time stamp for the items
    public override func awakeFromInsert() {
        // Whenever an item is created this function will be called
        super.awakeFromInsert()
        
        // Setting the attribute "created" on the .xcdatamodeld to the current date
        self.created = NSDate()
    }
}
