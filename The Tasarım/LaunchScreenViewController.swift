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
import Lottie

class LaunchScreenViewController: UIViewController {
    
    let animationView = LottieAnimationView()
    
    @IBOutlet var progressView: UIProgressView!
    let db = Firestore.firestore()
    let storage = Storage.storage()
    var loadedItemCount = 0
    private var selectedCategory = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryArray = []
        productCategories = []
        products = []
        productArray = []
        
        var progressValue: Float = 0.0
        let timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            progressValue += 0.02
            self.progressView.setProgress(progressValue, animated: true)
            if progressValue >= 1.0 {
                
            }
        }
        let animationView = LottieAnimationView(name: "animation")
        animationView.frame = CGRect(x: (view.bounds.width - 160) / 2, y: 550, width: 160, height: 160)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        self.view.addSubview(animationView)
        
        addProductCategories(){
            self.getProductNames(){
                self.getCategoryImage()
                self.getProductImage(){
                    self.selectedCategory = categoryArray[0].categoryName
                    self.fixCollectionViewData()
                    self.categoryClicked()
                    self.progressView.setProgress(0.8, animated: false)
                    self.progressView.setProgress(0.9, animated: false)
                    self.progressView.setProgress(1.0, animated: false)
                    timer.invalidate()
                    self.navigateToViewController()
                    animationView.stop()
                }
            }
        }
    }
    
    func navigateToViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let navigationController = self.navigationController {
            let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            navigationController.pushViewController(viewController, animated: true)
        } else {
            print("Navigation controller not found")
        }
    }
    func addProductCategories(completion: @escaping () -> Void) {
        db.collection("Category").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    productCategories.append(document.documentID)
                }
                completion() // çağrılan fonksiyonu burada çağırın
            }
        }
    }
    func getProductNames(completion: @escaping () -> Void){
        var numFinishedFetches = 0
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
                // artık bir koleksiyondan veri indirme işlemi tamamlandı
                numFinishedFetches += 1
                if numFinishedFetches == productCategories.count {
                    completion()
                }
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
    func getProductImage(completion: @escaping () -> Void) {
        // DispatchGroup oluştur
        let group = DispatchGroup()
        
        // Product Categories içerisindeki kategoriler
        for index in 0..<productCategories.count {
            let storageRef = self.storage.reference()
            let imagesRef = storageRef.child("developer@gmail.com")
            let images1Ref = imagesRef.child("Products")
            let images2Ref = images1Ref.child(productCategories[index])
            
            for item in 0..<products.count {
                let images3Ref = images2Ref.child(products[item])
                let image1 = images3Ref.child("image1")
                let image2 = images3Ref.child("image2")
                let image3 = images3Ref.child("image3")
                
                let product = productBrain(productCategory: productCategories[index], productName: products[item], productDetail: "", productPrice: "", image1: UIImage(named: "logo")!, image2: UIImage(named: "logo")!, image3: UIImage(named: "logo")!)
                
                group.enter()
                db.collection("developer@gmail.com").document("Products").collection(productCategories[index]).document(products[item]).getDocument { (document, error) in
                    if let document = document, document.exists {
                        let data = document.data()
                        product.productDetail = data!["detail"] as! String
                        product.productPrice = data!["price"] as! String
                    } else {
                        print("Document does not exist")
                    }
                    group.leave()
                }
                
                group.enter()
                image1.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
                    if let error = error {
                        print("Error downloading image: \(error.localizedDescription)")
                    } else {
                        let image1 = UIImage(data: data!)
                        product.image1 = image1!
                    }
                    group.leave()
                }
                
                group.enter()
                image2.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
                    if let error = error {
                        print("Error downloading image: \(error.localizedDescription)")
                    } else {
                        let image2 = UIImage(data: data!)
                        product.image2 = image2!
                    }
                    group.leave()
                }
                
                group.enter()
                image3.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
                    if let error = error {
                        print("Error downloading image: \(error.localizedDescription)")
                    } else {
                        let image3 = UIImage(data: data!)
                        product.image3 = image3!
                    }
                    group.leave()
                }
                productArray.append(product)
            }
        }
        
        // Bütün işlemler tamamlandığında
        group.notify(queue: .main) {
            completion()
        }
    }
    
    func fixCollectionViewData() {
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
    func categoryClicked(){
        collectionViewData = []
        for prdct in productArray{
            if prdct.productCategory == selectedCategory{
                collectionViewData.append(prdct)
            }
        }
    }
}
