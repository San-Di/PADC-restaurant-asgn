//
//  FoodCategoryCollectionViewCell.swift
//  RestaurantAsgn
//
//  Created by Sandi on 10/23/19.
//  Copyright © 2019 Sandi. All rights reserved.
//

import UIKit

class FoodCategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblCategoryName: UILabel!
    
    var categoryName: String!{
        didSet{
            lblCategoryName.text = categoryName
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewContainer.layer.cornerRadius = 18
        
    }

}
