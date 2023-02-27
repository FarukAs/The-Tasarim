//
//  DeveloperViewController.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 26.01.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
class DeveloperViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    let storage = Storage.storage()
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser?.email
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        
        // burada uygulamanın internetten veri indirmesini beklemek için bekleme yuvarlağı konulacak
        categoryArray = []
        getCategoryData()
        productArray = []
        getProductData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell" , for: indexPath) as! TableViewCell
        cell.label.text = "Ürün ekle"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        if index == 0 {
            performSegue(withIdentifier: "developerToProductEdit", sender: nil)
        }
        if index == 2 {
            performSegue(withIdentifier: "developerToUsers", sender: nil)
        }
    }
    func getCategoryData(){
        let storageRef = self.storage.reference()
        let imagesRef = storageRef.child(self.user!)
        let images1Ref = imagesRef.child("Category")
        
        images1Ref.listAll { (result, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            for prefix in result!.prefixes {
                let categoryName = prefix.name
                
                let images2Ref = images1Ref.child(categoryName)
                let reference = images2Ref.child("categoryImage")
                reference.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
                    if let error = error {
                        print("Error downloading image: \(error.localizedDescription)")
                    } else {
                        let image = UIImage(data: data!)
                        categoryArray.append(categorBrain(categoryName: categoryName, categoryImage: image!))
                        print("cc\(image.debugDescription)")
                    }
                }
                    
            }
        }
    }
    
    func getProductData(){
        
        
        
        
        
        
        
        
        
        
        ///
        let storageRef = self.storage.reference()
        let imagesRef = storageRef.child(self.user!)
        let images1Ref = imagesRef.child("Products")
        
        images1Ref.listAll { (result, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            for prefix in result!.prefixes {
                let categoryName = prefix.name
                let images2Ref = images1Ref.child(categoryName)
                let reference = images2Ref.child("categoryImage")
                reference.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
                    if let error = error {
                        print("Error downloading image: \(error.localizedDescription)")
                    } else {
                        let image = UIImage(data: data!)
                        categoryArray.append(categorBrain(categoryName: categoryName, categoryImage: image!))
                        print("cc\(image.debugDescription)")
                    }
                }
                images2Ref.listAll { result1, error in
                    if let error = error{
                        print("Error: \(error.localizedDescription)")
                        return
                    }
                    
                    // burası bir ürün
                    
                    for prefix1 in result1!.prefixes {

                
                        let productName = prefix1.name
                        
                        var product = productBrain(productCategory: "", productName: "", productDetail: "", productPrice: "", image1: UIImage(named: "logo")!, image2: UIImage(named: "logo")!, image3: UIImage(named: "logo")!)
                        
                        
                        self.db.collection(self.user!).document("Products").collection(categoryName).document(productName).getDocument { (document, error) in
                            if let document = document, document.exists {
                                let data = document.data()
                                product.productCategory = data!["category"] as! String
                                product.productName = data!["name"] as! String
                                product.productDetail = data!["detail"] as! String
                                product.productPrice = data!["price"] as! String
                               
                            } else {
                                print("Document does not exist")
                            }
                        }
                        
                        
                        
                        
                        
                        
                        let images3Ref = images2Ref.child(productName)
                        let image1  = images3Ref.child("image1")
                        let image2 = images3Ref.child("image2")
                        let image3 = images3Ref.child("image3")
                        image1.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
                            if let error = error {
                                print("Error downloading image: \(error.localizedDescription)")
                            } else {
                                let image1 = UIImage(data: data!)
                                product.image1 = image1!
                            }
                        }
                        image2.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
                            if let error = error {
                                print("Error downloading image: \(error.localizedDescription)")
                            } else {
                                let image2 = UIImage(data: data!)
                                product.image2 = image2!
                            }
                        }
                        image3.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
                            if let error = error {
                                print("Error downloading image: \(error.localizedDescription)")
                            } else {
                                let image3 = UIImage(data: data!)
                                product.image3 = image3!
                            }
                        }
                        productArray.append(product)
                        
                    }
                }
                

                
                
            }
        }
    }

}
