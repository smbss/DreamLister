//
//  ItemCell.swift
//  DreamLister
//
//  Created by smbss on 05/09/16.
//  Copyright © 2016 smbss. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var details: UILabel!
    
        // Creating the primary configure cell function
    func configureCell(item: Item) {
        title.text = item.title
        price.text = "$\(item.price)"
        details.text = item.details
        thumb.image = item.toImage?.image as? UIImage
            // Adding this last line makes the default image disapear from the cells
    }
}
