//
//  ResearchDetailTVC.swift
//  floodPrototype
//
//  Created by Mark Xue on 11/19/15.
//  Copyright © 2015 Mark Xue. All rights reserved.
//

import UIKit

class ResearchDetailTVC: UITableViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nutritionLabel: UILabel!
    @IBOutlet weak var servingLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var waterLabel: UILabel!
    
    @IBOutlet var waterDrops:[UIImageView]!
    
    var detailResult : [String:AnyObject]?
    let foodData = NSUserDefaults.standardUserDefaults().dictionaryForKey("foodDictionary")
    var suggestions:[[String:AnyObject]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let standardBlue = UIColor(colorLiteralRed: 74/255,
            green: 135/255, blue: 238/255, alpha: 100/255)
        
        navigationController?.navigationBar.barTintColor = standardBlue
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        tableView.estimatedRowHeight = 300.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //tableView.tableFooterView = UIView()
        update()
        
       
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func update(){
        guard let data = detailResult,
            name = data["name"] as? String,
            servingSize = data["servingSize"] as? String,
            calories = data["calories"] as? Int,
            fat = data["fatGrams"] as? Int,
            protein = data["proteinGrams"] as? Int,
            rating = data["rating"] as? Int,
            details = data["text"] as? String,
            waterUsage = data["waterUsageGalPerLb"] as? Int else {
            return
        }
        
        nameLabel.text = name
        servingLabel.text = "Serving Size: \(servingSize)"
        calorieLabel.text = "Calories: \(calories)"
        fatLabel.text = "Fat: \(fat) grams"
        proteinLabel.text = "Protein: \(protein) grams"
        detailsLabel.text = "Details:\n\(details)"
        detailsLabel.sizeToFit()
        let orangeColor = UIColor(red: 255/255, green: 103/255, blue: 0, alpha: 1)
        waterLabel.text = "\(waterUsage) gal/lb"
        waterLabel.textColor = orangeColor
        
        
        for i in 0...4{
            if i < rating {
                waterDrops[i].image = UIImage(named: "waterBlue")
                waterDrops[i].alpha = 1
            }else{
                waterDrops[i].image = UIImage(named: "waterGrey")
                waterDrops[i].alpha = 0.5
            }
        }
        guard let suggestionNames = data["suggestions"] as? [String],
            sDictionary = foodData else {
                return
        }
        for suggestion in suggestionNames {
            for key in sDictionary.keys {
                if var result = sDictionary[key] as? [String:AnyObject]
                    where key == suggestion {
                        result["name"] = key;
                        suggestions.append(result)
                }
                
            }
        }
    
        tableView.setNeedsLayout()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(suggestions.count != 0) {return "Suggested Alternatives:"}
        return ""
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if suggestions.count != 0 {return suggestions.count}
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("researchCell", forIndexPath: indexPath)
        if let researchCell = cell as? researchTVCell{
            researchCell.updateWith(suggestions[indexPath.row])
        }
        
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
