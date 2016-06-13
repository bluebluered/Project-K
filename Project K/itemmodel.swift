//
//  itemmodel.swift
//  2
//
//  Created by Jacob Lin on 6/5/16.
//  Copyright © 2016 Jacob Lin. All rights reserved.
//

import Foundation

class itemmodel: NSObject {
    
    //properties
    
    var Name: String?
    var Brief_Description: String?
    var Description: String?
    var Contact: String?
    var WeChatID: String?
    
    
    //empty constructor
    
    override init()
    {
        
    }
    
    //construct with @name, @address, @latitude, and @longitude parameters
    
    init(name: String, Brief_Description: String, Description: String, Contact: String, WeChatID: String) {
        
        self.Name = name
        self.Brief_Description = Brief_Description
        self.Description = Description
        self.Contact = Contact
        self.WeChatID = WeChatID
        
    }
    
    
    //prints object's current state
    
    override var description: String {
        return "Name: \(Name), Brief_Description: \(Brief_Description), Discription: \(Description), Contact: \(Contact), WeChatID: \(WeChatID)"
        
    }
    
    
}
