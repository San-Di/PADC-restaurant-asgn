//
//  ViewController.swift
//  RestaurantAsgn
//
//  Created by Sandi on 10/23/19.
//  Copyright © 2019 Sandi. All rights reserved.
//

import UIKit
import Floaty
import SDWebImage
import FirebaseStorage
import FirebaseFirestore

class ViewController: UIViewController {
    
    var foodCategories: [String] = ["Desserts", "Drinks", "Entrees", "Mains"]
    
    var selectedCategory: String = "Desserts"
    
    @IBOutlet weak var tablviewFoodLIst: UITableView!
    @IBOutlet weak var collectionViewCategoryList: UICollectionView!
    
    @IBOutlet weak var viewFloatingButton: Floaty!
    @IBOutlet weak var viewRestRating: UIView!
    
    var imgReference: StorageReference?
    
    var foodItems = [FoodItemVO]()
    
    var listener: ListenerRegistration!
    
    var query: Query?{
        didSet {
            if let listener = listener {
                listener.remove()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchFoodAccCategory()
    }
    func baseQuery() -> Query {
        return Firestore.firestore().collection(selectedCategory)
    }
    
    func fetchFoodAccCategory() {
        self.query = baseQuery()
        self.listener = query?.addSnapshotListener({ (querySnapShot, err) in
            if let err = err {
              print(err.localizedDescription)
                return
            }
            let results = querySnapShot?.documents.map({ (doc) -> FoodItemVO in
              print("DATA \(doc.data())")
                if let foodItem = FoodItemVO(dictionary: doc.data(), id: doc.documentID) {
                    return foodItem
                }else{
                    fatalError()
                }
            })

          self.foodItems = results ?? []
          self.tablviewFoodLIst.reloadData()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.query = baseQuery()
        
        viewRestRating.layer.cornerRadius = viewRestRating.bounds.height / 2
        tablviewFoodLIst.delegate = self
        tablviewFoodLIst.dataSource = self
        
        collectionViewCategoryList.delegate = self
        collectionViewCategoryList.dataSource = self
        
//        viewFloatingButton.del
        tablviewFoodLIst.register(UINib(nibName: String(describing: FoodItemTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: FoodItemTableViewCell.self))
        
        collectionViewCategoryList.register(UINib(nibName: String(describing: FoodCategoryCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: FoodCategoryCollectionViewCell.self))
        
        let tapGusterRecognizer = UITapGestureRecognizer(target: self, action: #selector(onCreateFoodItem))
        viewFloatingButton.addGestureRecognizer(tapGusterRecognizer)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(true)
           self.listener.remove()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SharedConstant.SEGUE_CREATE_FOOD_ITEM {
            let dvc = segue.destination as! CreateFoodItemViewController
            dvc.mFoodCategory = selectedCategory
        }
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == SharedConstant.SEGUE_CREATE_FOOD_ITEM {
//            let dvc = segue.destination as! CreateFoodItemViewController
////            dvc.objectToInject = object
//        }
//    }
    
    @objc func onCreateFoodItem(){
        self.performSegue(withIdentifier: SharedConstant.SEGUE_CREATE_FOOD_ITEM, sender: self)
    }

}

extension ViewController: UITableViewDelegate{
}
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FoodItemTableViewCell.self), for: indexPath) as? FoodItemTableViewCell else {
            return UITableViewCell()
        }
        
        cell.food = foodItems[indexPath.row]
        return cell
        
    }
}

extension ViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        
        let cell = collectionView.cellForItem(at: indexPath) as! FoodCategoryCollectionViewCell
        cell.viewContainer.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.00)
        cell.lblCategoryName.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        collectionView.deselectItem(at: indexPath, animated: true)
        return true
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! FoodCategoryCollectionViewCell
        cell.lblCategoryName.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.viewContainer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//
        selectedCategory = foodCategories[indexPath.row]
        fetchFoodAccCategory()
    }
}

extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodCategories.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FoodCategoryCollectionViewCell.self), for: indexPath) as! FoodCategoryCollectionViewCell
        cell.categoryName = foodCategories[indexPath.row]
        return cell
    }
    
}


extension ViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width / 4) - 10;
        return CGSize(width: width, height: 60)
    }
}

