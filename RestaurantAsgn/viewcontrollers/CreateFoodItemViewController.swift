//
//  CreateFoodItemViewController.swift
//  RestaurantAsgn
//
//  Created by Sandi on 10/24/19.
//  Copyright © 2019 Sandi. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class CreateFoodItemViewController: UIViewController {

    @IBOutlet weak var imgItemPreview: UIImageView!
    
    @IBOutlet weak var txtAmount: UITextField!
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtRating: UITextField!
    
    @IBOutlet weak var txtWaitingTime: UITextField!
    
    var mFoodCategory: String!
    
    var imgReference: StorageReference?
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        let imageName = UUID().uuidString
        imgReference = Storage.storage().reference().child("image").child(imageName)
    }
    
    @IBAction func btnUploadImage(_ sender: Any) {
        ImagePickerManager().pickImage(self) { (image) in
            self.imgItemPreview.image = image
        }
//        uploadImage()
    }
    

    @IBAction func btnCreateFoodItem(_ sender: Any) {
        uploadFoodItem()
    }
    
    func uploadFoodItem() {
        
       let amount = txtAmount.text ?? ""
       let name = txtName.text ?? ""
       let rating = txtRating.text ?? ""
       let waitingTime = txtWaitingTime.text ?? ""
       
       var imgUrl = ""
               
        
        guard let img = self.imgItemPreview.image, let data = img.jpegData(compressionQuality: 0.8) else {
            return
        }
        
        imgReference?.putData(data, metadata: nil, completion: { (metadata, err) in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            
            self.imgReference?.downloadURL(completion: { (url, err) in
                if let err = err {
                    print(err.localizedDescription)
                    return
                }
                
                imgUrl = url?.absoluteString ?? ""

                self.db.collection(self.mFoodCategory ).addDocument(data: [
                    "amount" : amount,
                    "food_name": name,
                    "rating": rating,
                    "imageUrl": imgUrl,
                    "waiting_time": waitingTime,
                ])
            })
            

        })
    }
    
    
    func baseQuery() -> Query {
        return Firestore.firestore().collection(mFoodCategory )
    }
    
    func getAllTasksFromStore(){
        db.collection(mFoodCategory ).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
}
