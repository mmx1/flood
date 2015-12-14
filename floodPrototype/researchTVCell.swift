//
//  researchTVCell.swift
//  floodPrototype
//
//  Created by Mark Xue on 11/16/15.
//  Copyright © 2015 Mark Xue. All rights reserved.
//

import UIKit

class researchTVCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nutritionLabel: UILabel!
    @IBOutlet weak var servingLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var waterLabel: UILabel!
    
    @IBOutlet var waterDrops:[UIImageView]!
    
    override func awakeFromNib() {

        super.awakeFromNib()
        
        // Initialization code
    }
    
    func updateWith(searchResult:[String:AnyObject]){
        //nutritionLabel.text = "Nutrition Facts"
        guard let name = searchResult["name"] as? String,
            servingSize = searchResult["servingSize"] as? String,
            calories = searchResult["calories"] as? Int,
            fat = searchResult["fatGrams"] as? Int,
            protein = searchResult["proteinGrams"] as? Int,
            rating = searchResult["rating"] as? Int,
            waterUsage = searchResult["waterUsageGalPerLb"] as? Int else {
                return
        }
        nameLabel.text = name
        servingLabel.text = "Serving Size: \(servingSize)"
        calorieLabel.text = "Calories: \(calories)"
        fatLabel.text = "Fat: \(fat) grams"
        proteinLabel.text = "Protein: \(protein) grams"
        //waterLabel.text = "Water usage: \(searchResult["name"]) gal/lb"
        
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
        
        setNeedsLayout()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
