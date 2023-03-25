//
//  LaunchScreenViewController.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 24.03.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
class LaunchScreenViewController: UIViewController {
    
    @IBOutlet var progressView: UIProgressView!
    let db = Firestore.firestore()
    let storage = Storage.storage()
    var loadedItemCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryArray = []
        productCategories = []
        products = []
        productArray = []
        
        var progressValue: Float = 0.0
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            progressValue += 0.125
            self.progressView.setProgress(progressValue, animated: true)
            
            if progressValue >= 1.0 {
                timer.invalidate()
                
                self.navigateToViewController()
            }
        }
        addProductCategories()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.getProductNames()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.getCategoryImage()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.getProductImage()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) {
            self.fixCollectionView()
        }
    }
    
    func navigateToViewController() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            viewController.modalPresentationStyle = .fullScreen
            viewController.modalTransitionStyle = .crossDissolve
            self.present(viewController, animated: true, completion: nil)
        }
    
    
    
    
    func addProductCategories(){
        db.collection("Category").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    productCategories.append(document.documentID)
                }
                print("Number of categories: \(productCategories.count)")
            }
        }
    }
    func getCategoryImage(){
        for index in 0..<productCategories.count {
            let storageRef = self.storage.reference()
            let imagesRef = storageRef.child("developer@gmail.com")
            let images1Ref = imagesRef.child("Category")
            let images2Ref = images1Ref.child(productCategories[index])
            let images3Ref = images2Ref.child("categoryImage")
            
            images3Ref.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
                if let error = error {
                    print("Error downloading image: \(error.localizedDescription)")
                } else {
                    let image = UIImage(data: data!)
                    categoryArray.append(categorBrain(categoryName: productCategories[index], categoryImage: image!))
                    print("done")
                }
            }
        }
    }
    func getProductImage(){
        // Product Categories içerisindeki kategoriler
        for index in 0..<productCategories.count {
            let storageRef = self.storage.reference()
            let imagesRef = storageRef.child("developer@gmail.com")
            let images1Ref = imagesRef.child("Products")
            let images2Ref = images1Ref.child(productCategories[index])
            
            for item in 0..<products.count{
                
                let images3Ref = images2Ref.child(products[item])
                let image1 = images3Ref.child("image1")
                let image2 = images3Ref.child("image2")
                let image3 = images3Ref.child("image3")
                
                let product = productBrain(productCategory: productCategories[index], productName: products[item], productDetail: "", productPrice: "", image1: UIImage(named: "logo")!, image2: UIImage(named: "logo")!, image3: UIImage(named: "logo")!)
                
                //Load fonksiyonu
                let loadCompletion = { [self] in
                    loadedItemCount += 1
                    if loadedItemCount == productCategories.count * products.count * 3 {
                        // Tüm ürünler yüklendiğinde hideLoader() fonksiyonunu çağırmak için
//                        hideLoader()
                    }
                }
                
                db.collection("developer@gmail.com").document("Products").collection(productCategories[index]).document(products[item]).getDocument { (document, error) in
                    if let document = document, document.exists {
                        let data = document.data()
                        product.productDetail = data!["detail"] as! String
                        product.productPrice = data!["price"] as! String
                    } else {
                        print("Document does not exist")
                    }
                    loadCompletion()
                }
                image1.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
                    if let error = error {
                        print("Error downloading image: \(error.localizedDescription)")
                    } else {
                        let image1 = UIImage(data: data!)
                        product.image1 = image1!
                    }
                    loadCompletion()
                }
                image2.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
                    if let error = error {
                        print("Error downloading image: \(error.localizedDescription)")
                    } else {
                        let image2 = UIImage(data: data!)
                        product.image2 = image2!
                    }
                    loadCompletion()
                }
                
                image3.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
                    if let error = error {
                        print("Error downloading image: \(error.localizedDescription)")
                    } else {
                        let image3 = UIImage(data: data!)
                        product.image3 = image3!
                    }
                    loadCompletion()
                }
                productArray.append(product)
                
            }
        }
    }
    func getProductNames(){
        for index in 0..<productCategories.count {
            let ref = self.db.collection("developer@gmail.com").document("Products").collection(productCategories[index])
            ref.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print(error)
                }else {
                    for document in querySnapshot!.documents {
                        products.append("\(document.documentID)")
                        print(products)
                    }
                }
            }
        }
    }
    func fixCollectionView() {
        var indexesToRemove: [Int] = []
        for index in 0..<productArray.count {
            if productArray[index].productDetail == "" {
                indexesToRemove.append(index)
            }
        }
        for index in indexesToRemove.reversed() {
            productArray.remove(at: index)
        }
    }
}
