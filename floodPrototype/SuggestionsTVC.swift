//
//  SuggestionsTVC.swift
//  floodPrototype
//
//  Created by Mark Xue on 12/3/15.
//  Copyright © 2015 Mark Xue. All rights reserved.
//

import UIKit

class SuggestionsTVC: showReceiptTVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        receiptDict = NSUserDefaults.standardUserDefaults().objectForKey("lastReceipt") as? [String:AnyObject]
        navigationItem.title = "Suggestions"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let dict = receiptDict,
            let id = dict["id"] as? String,
            let thisReceipt = receipts[id] as? [String:AnyObject],
            let receiptTotal = thisReceipt["total"] as? Float,
            let chartImage = thisReceipt["chartImage"] as? String {
                resultLabel.text = "You used \(receiptTotal) gal of water.\nThat's over your goal."
                
                chart.image = UIImage(named: chartImage)
                
                
        }else{
            resultLabel.text = "Hello Jason"
            chart.image = UIImage(named: "profile")
        }
        resultLabel.sizeToFit()
        tableView.tableHeaderView?.setNeedsDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        navigationItem.title = "Suggestions"
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Your biggest water users"
        }
        return ""
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dict = receiptDict,
            let id = dict["id"] as? String,
            let thisReceipt = receipts[id] as? [String:AnyObject],
            let _ = thisReceipt["items"] as? [String] else{
                return 1
        }
        return 2
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
           guard let dict = receiptDict,
            let id = dict["id"] as? String,
            let thisReceipt = receipts[id] as? [String:AnyObject],
            let receiptItems = thisReceipt["items"] as? [String] else {
                let cell = tableView.dequeueReusableCellWithIdentifier("textCell", forIndexPath: indexPath)
                cell.textLabel?.text = "You haven't scanned a receipt yet"
                return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("receiptCell", forIndexPath: indexPath)
        (cell as? receiptCell)?.updateWith(receiptItems[indexPath.row])
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
