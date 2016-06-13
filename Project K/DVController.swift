//
//  DVController.swift
//  3
//
//  Created by Jacob Lin on 6/6/16.
//  Copyright © 2016 Jacob Lin. All rights reserved.
//

import UIKit

class DVController:UIViewController{
    var item:itemmodel!
    var category:String = ""
    
    @IBOutlet weak var PosterPlaceHolder: UILabel!
    @IBOutlet weak var CatePlaceHolder: UILabel!
    @IBOutlet weak var DescriptionPlaceHolder: UILabel!
    @IBOutlet weak var ContactPlaceHolder: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        PosterPlaceHolder.text = item.Name
        
        //Need to change
        CatePlaceHolder.text = category
        
        DescriptionPlaceHolder.text = item.Description
        ContactPlaceHolder.text = item.Contact
    }
}
