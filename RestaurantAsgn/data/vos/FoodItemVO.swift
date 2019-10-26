//
//  FoodItemVO.swift
//  RestaurantAsgn
//
//  Created by Sandi on 10/26/19.
//  Copyright © 2019 Sandi. All rights reserved.
//

import Foundation

struct FoodItemVO {
    var amount: String?
    var foodName: String?
    var imageUrl: String?
    var rating: String?
    var waitingTime: String?
    var id: String?
    
    var dictionary: [String: Any] {
        return [
            "amount": amount ?? "",
            "food_name": foodName,
            "imageUrl": imageUrl,
            "rating": rating,
            "waitingTime": waitingTime
            
        ]
        
    }
}
extension FoodItemVO{
    init?(dictionary: [String: Any], id: String) {
        
        guard let amount = dictionary["amount"] as? String, let foodName = dictionary["food_name"] as? String, let imageUrl = dictionary["imageUrl"] as? String, let rating = dictionary["rating"] as? String, let waitingTime = dictionary["waiting_time"] as? String else{
            return nil
        }
        
        self.init(amount: amount, foodName: foodName, imageUrl: imageUrl, rating: rating, waitingTime: waitingTime, id: id)
    }
}

