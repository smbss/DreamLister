//
//  ItemType+CoreDataProperties.swift
//  DreamLister
//
//  Created by Sandro Simes on 14/09/16.
//  Copyright © 2016 smbss. All rights reserved.
//

import Foundation
import CoreData 

extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType");
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
