//
//  receiptCell.swift
//  floodPrototype
//
//  Created by Mark Xue on 12/3/15.
//  Copyright © 2015 Mark Xue. All rights reserved.
//

import UIKit

class receiptCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var waterDrops:[UIImageView]!
    let foodDict = NSUserDefaults.standardUserDefaults().dictionaryForKey("foodDictionary")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateWith(name:String){

        if let foodDictionary = foodDict{
            for key in foodDictionary.keys {
            if let entry = foodDictionary[key] as? [String:AnyObject],
                rating = entry["rating"] as? Int
                where key.lowercaseString.rangeOfString(name.lowercaseString) != nil {
                    nameLabel.text = key
                    
                    for i in 0...4{
                        if i < rating {
                            waterDrops[i].image = UIImage(named: "waterBlue")
                        }else{
                            waterDrops[i].image = UIImage(named: "waterGrey")
                        }
                    }
                    
                    setNeedsLayout()
                    
                }
                
            }
        }
    }
    
}
