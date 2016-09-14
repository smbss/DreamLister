//
//  Store+CoreDataProperties.swift
//  DreamLister
//
//  Created by smbss on 14/09/16.
//  Copyright © 2016 smbss. All rights reserved.
//

import Foundation
import CoreData

extension Store {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Store> {
        return NSFetchRequest<Store>(entityName: "Store");
    }

    @NSManaged public var name: String?
    @NSManaged public var toImage: Image?
    @NSManaged public var toItem: Item?

}
