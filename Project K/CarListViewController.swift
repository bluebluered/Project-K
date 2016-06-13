//
//  CarListViewController.swift
//  3
//
//  Created by Jacob Lin on 6/6/16.
//  Copyright © 2016 Jacob Lin. All rights reserved.
//

import UIKit

class CarListViewController: UIViewController,UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, DownloaderProtocal {
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBAction func refresh(sender: AnyObject) {
        searchBar.resignFirstResponder()
        self.view.endEditing(true)
        let downloader = Downloader(cateid: 1)
        downloader.delegate = self
        downloader.downloadItems()

    }
    
    //Properties
    
    var feedItems: NSArray = NSArray()
    var selectedItem : itemmodel = itemmodel()
    var searchActive = false
    var titleset:[String]=[]
    var filtered:[String] = []
    var searchresult: NSMutableArray=NSMutableArray()
    
    var readyForSearch = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //set delegates and initialize downloader
        
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        self.searchBar.delegate = self
        
        let downloader = Downloader(cateid: 1)
        downloader.delegate = self
        downloader.downloadItems()
        searchBar.userInteractionEnabled = false
        listTableView.separatorInset = UIEdgeInsetsZero
        
        listTableView.becomeFirstResponder()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func itemsDownloaded(items: NSArray) {
        readyForSearch = false
        feedItems = items
        if feedItems.count>0 {
            self.listTableView.reloadData()
            readyForSearch = true
            searchBar.userInteractionEnabled=true
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Retrieve cell
        listTableView.separatorInset = UIEdgeInsetsZero
        
        let cellIdentifier: String = "CarBasicCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)!
        if (searchActive && readyForSearch) && searchBar.text != "" {
            print("ok")
            let item: itemmodel = searchresult[indexPath.row] as! itemmodel
            myCell.textLabel?.text = item.Brief_Description
        } else {
            
            let totalrows = feedItems.count-1
            let item: itemmodel = feedItems[totalrows - indexPath.row] as! itemmodel

            myCell.textLabel!.text = item.Brief_Description
            titleset.append(item.Brief_Description!)
            
            if indexPath.row == feedItems.count-1 {
                readyForSearch = true
            }
            
            
        }
        myCell.separatorInset = UIEdgeInsetsZero
        myCell.layoutMargins = UIEdgeInsetsZero
        return myCell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToDetailSegue" {
            let controller: DVController = segue.destinationViewController as! DVController
            controller.item = selectedItem
            controller.category = "Car"
            controller.hidesBottomBarWhenPushed = true
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        searchBar.resignFirstResponder()
        self.view.endEditing(true)
        if searchActive && searchBar.text != "" {
            selectedItem = searchresult[indexPath.row] as! itemmodel
            self.performSegueWithIdentifier("goToDetailSegue", sender: self)
        } else {
            selectedItem = feedItems[feedItems.count-1-indexPath.row] as! itemmodel
            self.performSegueWithIdentifier("goToDetailSegue", sender: self)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of feed items
        if(searchActive && readyForSearch) && searchBar.text != ""  {
            return searchresult.count
        } else  {
            return feedItems.count
        }
        
    }
    
    
    
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        if readyForSearch {
            searchActive = true;
        }
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        listTableView.becomeFirstResponder()
        self.view.endEditing(true)
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.view.endEditing(true)
        searchBar.resignFirstResponder()
        listTableView.becomeFirstResponder()
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if readyForSearch {
            searchBar.userInteractionEnabled = true
        } else {
            searchBar.userInteractionEnabled = false
        }
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {

        filtered=[]
        if readyForSearch {
            filtered=[]
            filtered = titleset.filter({ (text) -> Bool in
                let tmp: NSString = text
                let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
                return range.location != NSNotFound
            })
    
            searchresult=NSMutableArray()
            for item in feedItems {
                if filtered.contains(item.Brief_Description!!){
                searchresult.addObject(item)
                }
        
            }
            self.listTableView.reloadData()
        }
    }
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            searchBar.resignFirstResponder()
            listTableView.becomeFirstResponder()
            return false
        } else {
            
            return true
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        searchBar.resignFirstResponder()
        listTableView.becomeFirstResponder()
    }
    
}




