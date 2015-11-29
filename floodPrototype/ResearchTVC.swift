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
    
        title = "Research"
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.searchBarStyle = .Prominent
        
        view.tintColor = UIColor.whiteColor()
        
        //searchController.searchBar.tintColor = UIColor.whiteColor();
        
        tableView.tableHeaderView = searchController.searchBar
        //tableView.delegate = self
        
        tableView.tableFooterView = UIView() //adds footer to hide extra separators
        
        //prevents clearing when returning from tab controller
        definesPresentationContext = true
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        searchController.searchBar.hidden = false
        tableView.setNeedsLayout()
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
        searchResults = []
        if let sDictionary = searchDictionary {
            for key in sDictionary.keys {
                if var result = sDictionary[key] as? [String:AnyObject]
                    where key.lowercaseString.rangeOfString(searchBar.text!.lowercaseString) != nil {
                    result["name"] = key;
                    searchResults.append(result)
                    print(key)
                }
                    
            }
        }
        tableView.reloadData()
        //enableCancelButton(searchBar)
    }
    
    func searchBarCancelButtonClicked(searchBar : UISearchBar){
        searchResults = []
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        //searchBar.setShowsCancelButton(true, animated: true)
        //enableCancelButton(searchBar)
    }
    
    func enableCancelButton(searchBar : UISearchBar){
        for view in searchBar.subviews {
            for subview in view.subviews {
                if let button = subview as? UIButton{
                    button.enabled = true
                    //button.tintColor = UIColor.whiteColor()
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
        if let researchCell = cell as? researchTVCell{
            researchCell.updateWith(searchResults[indexPath.row])
        }

        

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        searchController.searchBar.hidden = true
        if let detailVC = storyboard?.instantiateViewControllerWithIdentifier("ResearchDetailTVC") as? ResearchDetailTVC{
                detailVC.detailResult = searchResults[indexPath.row]
                navigationController?.pushViewController(detailVC, animated: true)
        }
        
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
