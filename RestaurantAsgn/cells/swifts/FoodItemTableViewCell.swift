//
//  FoodItemTableViewCell.swift
//  RestaurantAsgn
//
//  Created by Sandi on 10/23/19.
//  Copyright © 2019 Sandi. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage

class FoodItemTableViewCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgFoodItem: UIImageView!
    
    @IBOutlet weak var lblFoodName: UILabel!
    
    @IBOutlet weak var lblWaitingTime: UILabel!
    
    @IBOutlet weak var lblAmount: UILabel!
    
    @IBOutlet weak var viewRating: CosmosView!
    
        var food: FoodItemVO! {
        didSet{
            lblFoodName.text = food.foodName
            lblWaitingTime.text = food.waitingTime
            lblAmount.text = food.amount
            
            imgFoodItem.sd_setImage(with: URL(string: food.imageUrl ?? ""), placeholderImage: UIImage(named: "g"))
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        viewContainer.layer.cornerRadius = 10
        imgFoodItem.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
