//
//  downloader.swift
//  2
//
//  Created by Jacob Lin on 6/5/16.
//  Copyright © 2016 Jacob Lin. All rights reserved.
//

import Foundation

protocol DownloaderProtocal: class {
    func itemsDownloaded(items: NSArray)
}


class Downloader: NSObject, NSURLSessionDataDelegate {
    
    //properties
    var cate:Int = 0
    weak var delegate: DownloaderProtocal!
    
    var data : NSMutableData = NSMutableData()
    var urlPath: String = ""
    
    init(cateid: Int) {
        // 1 -> Car
        // 2 -> Apartment
        // 3 -> Other
        cate = cateid
        if cate == 1 {
            urlPath = "http://yichlin.com/findcar.php"
        } else if cate == 2 {
            urlPath = "http://yichlin.com/findapt.php"
        } else if cate == 3 {
            urlPath = "http://yichlin.com/findother.php"
        }
    }
    
    func downloadItems() {
    
        let url: NSURL = NSURL(string: urlPath)!
        var session: NSURLSession!
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
    
    
        session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    
        let task = session.dataTaskWithURL(url)
    
        task.resume()
    
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        self.data.appendData(data);
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if error != nil {
            //print("Failed to download data")
        }else {
            //print("Data downloaded")
            self.parseJSON()
        }
        
    }

    func parseJSON() {
        
        var jsonResult: NSMutableArray?
        do{
            jsonResult = try NSJSONSerialization.JSONObjectWithData(self.data, options:NSJSONReadingOptions.AllowFragments) as? NSMutableArray
            
            
        } catch let error as NSError {
            print(error)
            
        }
        
        if jsonResult != nil  {
            var jsonElement: NSDictionary = NSDictionary()
            let itemset: NSMutableArray = NSMutableArray()
        
            for(var i = 0; i < jsonResult!.count; i += 1){
                //print(jsonElement)
                jsonElement = jsonResult![i] as! NSDictionary
            
                let item = itemmodel()
            
                //the following insures none of the JsonElement values are nil through optional binding
                if let Name = jsonElement["Name"] as? String,
                    let Description = jsonElement["Description"] as? String,
                    let Contact = jsonElement["Contact"] as? String,
                    let WeChatID = jsonElement["WeChatID"] as? String,
                    let Brief_Description = jsonElement["Brief_Description"] as? String
                {
                    item.Name = Name
                    item.Description = Description
                    item.Brief_Description = Brief_Description
                    item.Contact = Contact
                    item.WeChatID = WeChatID
                
                }
            
                    itemset.addObject(item)
                }
        
        
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
                self.delegate.itemsDownloaded(itemset)
            })
            //print(jsonResult)
        } else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let itemset: NSMutableArray = NSMutableArray()
                self.delegate.itemsDownloaded(itemset)
            })
        }
    }
}
