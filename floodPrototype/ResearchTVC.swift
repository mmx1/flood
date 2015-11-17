//
//  ResearchTVC.swift
//  floodPrototype
//
//  Created by Mark Xue on 11/13/15.
//  Copyright © 2015 Mark Xue. All rights reserved.
//

import UIKit

class ResearchTVC: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate, UISearchDisplayDelegate{

    /*hardcoded model:
    */
    let foodData = NSUserDefaults.standardUserDefaults().dictionaryForKey("foodData")
    var searchController:UISearchController = UISearchController(searchResultsController: nil)
    var searchResults:[[String:AnyObject]] = []
    let searchDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey("foodDictionary")
        
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationController?.navigationBar.topItem?.title = "Research"
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar
        
        //definesPresentationContext = true;

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func searchFor(text:String){
    
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        searchFor(searchString!)
        tableView.reloadData()
    }
    
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResultsForSearchController(searchController)
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(searchBar : UISearchBar){
        //request.naturalLanguageQuery = searchBar.text
        print(searchBar.text)
        if let sDictionary = searchDictionary {
            for key in sDictionary.keys {
                if key.lowercaseString.rangeOfString(searchBar.text!.lowercaseString) != nil {
                    searchResults.append(sDictionary[key] as! [String:AnyObject])
                    print(key)
                }
                    
            }
        }
        
        enableCancelButton(searchBar)
    }
    
    func searchBarCancelButtonClicked(searchBar : UISearchBar){
        searchResults = []
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func enableCancelButton(searchBar : UISearchBar){
        for view in searchBar.subviews {
            for subview in view.subviews {
                if let button = subview as? UIButton{
                    button.enabled = true
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchResults.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("researchCell", forIndexPath: indexPath)


        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
