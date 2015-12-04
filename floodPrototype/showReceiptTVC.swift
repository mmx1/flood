//
//  showReceiptTVC.swift
//  floodPrototype
//
//  Created by Mark Xue on 12/3/15.
//  Copyright © 2015 Mark Xue. All rights reserved.
//

import UIKit

class showReceiptTVC: UITableViewController {
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var chart: UIImageView!
    
    var receiptDict:[String:AnyObject]?
    let receipts = [ "1ga3t15z": ["total":8237.25, "chartImage":"chart1", "items": ["Coffee", "Milk", "Eggs", "Beef","Pasta","Almonds", "Cheese", "Rice", "Lettuce"] ],
    "5f1t3t13": ["total":3382.55, "chartImage":"chart2", "items":["Oranges", "Rice", "Walnuts", "Potatoes"]],
    "35h35h24h24ht": ["total":12953.25, "chartImage":"chart3", "items":["Beef","Almonds","Pork","Soda","Coffee", "Chicken", "Pasta"]]
    ]
    let foodDict = NSUserDefaults.standardUserDefaults().dictionaryForKey("foodDictionary")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = "Scan"
        navigationItem.title = "Checkout"
        tableView.tableHeaderView?.backgroundColor = UIColor(colorLiteralRed: 64/255,
            green: 72/255, blue: 101/255, alpha: 1)
        


        let progressButton = UIBarButtonItem(title: "View Progress", style: .Plain, target: self, action: "openProgressTab")
        progressButton.tintColor = UIColor(colorLiteralRed: 49/255,
            green: 243/255, blue: 59/255, alpha: 1)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        toolbarItems = [flexibleSpace,progressButton,flexibleSpace]

        //        navigationController?.toolbar.setItems([flexibleSpace,progressButton,refreshButton,flexibleSpace] , animated: true)

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
            resultLabel.text = ""
            chart.image = nil
        }
        resultLabel.sizeToFit()
        tableView.tableHeaderView?.setNeedsDisplay()

        
        tableView.reloadData()
        navigationController?.navigationBarHidden = false
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.toolbarHidden = false;
        


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dict = receiptDict,
            let id = dict["id"] as? String,
            let thisReceipt = receipts[id] as? [String:AnyObject],
            let receiptItems = thisReceipt["items"] as? [String] else{
                return 0
        }
        return receiptItems.count

    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("receiptCell", forIndexPath: indexPath)
        guard let dict = receiptDict,
            let receiptCell = cell as? receiptCell,
            let id = dict["id"] as? String,
            let thisReceipt = receipts[id] as? [String:AnyObject],
            let receiptItems = thisReceipt["items"] as? [String] else {
            return cell
        }
        receiptCell.updateWith(receiptItems[indexPath.row])
        return cell
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Items:"
        }
        return ""
    }
    
    func openProgressTab(){
        tabBarController?.selectedIndex = 4
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let dict = receiptDict,
            let id = dict["id"] as? String,
            let thisReceipt = receipts[id] as? [String:AnyObject],
            let receiptItems = thisReceipt["items"] as? [String],
            let foodDictionary = foodDict,
            let detailVC = storyboard?.instantiateViewControllerWithIdentifier("ResearchDetailTVC") as? ResearchDetailTVC else {
                return
        }
        for key in foodDictionary.keys {
            if var entry = foodDictionary[key] as? [String:AnyObject]
                where key.lowercaseString.rangeOfString(receiptItems[indexPath.row].lowercaseString) != nil {
                    tabBarController?.selectedIndex = 3
                    if let navController = tabBarController?.selectedViewController as? UINavigationController{
                        navController.popToRootViewControllerAnimated(true)
                        entry["name"] = key
                        detailVC.detailResult = entry
                        print(entry)
                        navController.pushViewController(detailVC, animated: true)
                    }
            }
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
