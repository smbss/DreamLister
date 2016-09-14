//
//  MaterialView.swift
//  25-DreamLister
//
//  Created by Sandro Simes on 05/09/16.
//  Copyright © 2016 SandroSimes. All rights reserved.
//

import UIKit

    // Setting the default value to the Bool above to false
private var materialKey = false

    // Instead of creating a class we are going to do an extension to the UIView class so that we can use the code that we wrote in this file
extension UIView {

        // An @IBInspectable is a toggle/option that we can select inside the storyboard
    @IBInspectable var materialDesign: Bool {
        get {
            
            return materialKey
        }
        set {
            
            materialKey = newValue
            
            if materialKey {
                
                self.layer.masksToBounds = false
                self.layer.cornerRadius = 3.0
                self.layer.shadowOpacity = 0.8
                self.layer.shadowRadius = 3.0
                self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                self.layer.shadowColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1.0).cgColor
            } else {
                
                self.layer.cornerRadius = 0
                self.layer.shadowOpacity = 0
                self.layer.shadowRadius = 0
                self.layer.shadowColor = nil
            }
        }
        
    }
}
