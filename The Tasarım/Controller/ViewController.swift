//
//  ViewController.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 25.01.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import MBProgressHUD
class ViewController: UIViewController , UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet var categoryCollectionView: UICollectionView!
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var accountStackView: UIStackView!
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser?.email
    let storage = Storage.storage()
    var loadedItemCount = 0
    var selectedCategory = categoryArray[0].categoryName
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoader()
        collectionView.dataSource = self
        collectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        accountStackView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToLogin))
        accountStackView.addGestureRecognizer(tapGesture)
        categoryArray = []
        productCategories = []
        products = []
        productArray = []
        addProductCategories()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.getCategoryImage()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.8) {
            self.getProductNames()
        }
   
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.getProductImage()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) {
            self.fixCollectionView()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 13) {
            self.selectedCategory = categoryArray[0].categoryName
            self.categoryClicked()
            self.categoryCollectionView.reloadData()
            self.hideLoader()
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return collectionViewData.count
        }else{
            return categoryArray.count
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView{
        }else{
            selectedCategory = categoryArray[indexPath.item].categoryName
            categoryClicked()
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "ProductReusableCell", for: indexPath as IndexPath) as! ProductCollectionViewCell
            cell.imageView.image = UIImage(named: "pic")
            cell.likeButton.addTarget(self, action: #selector(likeButton), for: .touchUpInside)
            cell.likeButton.tag = indexPath.item
            
            cell.likeButton.layer.cornerRadius = 15
            cell.likeButton.layer.shadowColor = UIColor.black.cgColor
            cell.likeButton.layer.shadowOffset = CGSize(width: 2, height: 2)
            cell.likeButton.layer.shadowRadius = 8.0
            cell.likeButton.layer.shadowOpacity = 0.3
            cell.likeButton.layer.masksToBounds = false
            
            cell.layer.cornerRadius = 8.0
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 5, height: 5)
            cell.layer.shadowRadius = 8.0
            cell.layer.shadowOpacity = 0.5
            cell.layer.masksToBounds = false
            cell.backgroundColor = .white
            
            cell.imageView.image = collectionViewData[indexPath.item].image1
            cell.productTitle.text = collectionViewData[indexPath.item].productName
            cell.productPrice.text = "\(collectionViewData[indexPath.item].productPrice) TL"
            
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryReusableCell", for: indexPath as IndexPath) as! CategoryCollectionViewCell
            
            cell.imageView.image = categoryArray[indexPath.item].categoryImage
            cell.label.text = categoryArray[indexPath.item].categoryName
            
            return cell
        }
        
        
        
    }
    @objc func goToLogin() {
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "mainToAccount", sender: nil)
        } else {
            performSegue(withIdentifier: "mainToLogin", sender: nil)
        }
    }
    @objc func likeButton(sender: UIButton) {
        print("Like Button pressed")
    }
    func addProductCategories(){
        db.collection("Category").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    productCategories.append(document.documentID)
                    
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
    func showLoader() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = "Yükleniyor..."
    }
    func hideLoader() {
        for subview in view.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
        MBProgressHUD.hide(for: view, animated: true)
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
    func categoryClicked(){
        collectionViewData = []
        for prdct in productArray{
            if prdct.productCategory == selectedCategory{
                collectionViewData.append(prdct)
            }
        }
        collectionView.reloadData()
    }
}
