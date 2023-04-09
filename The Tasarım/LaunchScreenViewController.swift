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
import CoreData
class LaunchScreenViewController: UIViewController {
    
    let animationView = LottieAnimationView()
    
    @IBOutlet var progressView: UIProgressView!
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let user = Auth.auth().currentUser?.email
    var loadedItemCount = 0
    var itemtobedeletedfromthearray: [String] = []

    var numberOfProduct = Int()
    var numberOfCategory = Int()
    var categoriesDone = false
    var productsDone = false
    var productVariable = 0  {
        willSet(newValue) {
            if newValue == numberOfProduct {
                productsDone = true
                checkAndNavigate()
            }
        }
    }
    var categoryVariable = 0  {
        willSet(newValue) {
            if newValue == numberOfCategory {
                categoriesDone = true
                checkAndNavigate()
            }
        }
    }
    lazy var  constant = 1
    private var selectedCategory = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        getListedProducts()
        productDeletedByTheDeveloper()
        getNumberOfItems()
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
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.play()
        self.view.addSubview(animationView)
        addProductCategories(){
            self.getProductNames(){
                self.getCategoryImage(){
                    self.selectedCategory = categoryArray[0].categoryName
                }
                self.getProductImage(){
                    self.fixCollectionViewData(){
                        self.getFavoritesData(){
                            self.categoryClicked()
                            self.progressView.setProgress(0.8, animated: false)
                            self.progressView.setProgress(0.9, animated: false)
                            self.progressView.setProgress(1.0, animated: false)
                            timer.invalidate()
                            animationView.stop()
                        }
                    }
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
    func checkAndNavigate() {
        if categoriesDone && productsDone {
            self.navigateToViewController()
            productsDone = false
            categoriesDone = false
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
    
    func getCategoryImage(completion: @escaping () -> Void){
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
                    self.categoryVariable += 1
                }
                if self.categoryVariable == self.numberOfCategory {
                    completion()
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
                
                let product = productBrain(productCategory: productCategories[index], productName: products[item], productDetail: "", productPrice: "", averageRate: 5, timestamp: 123, image1: UIImage(named: "logo")!, image2: UIImage(named: "logo")!, image3: UIImage(named: "logo")!)
                
                group.enter()
                db.collection("developer@gmail.com").document("Products").collection(productCategories[index]).document(products[item]).getDocument { (document, error) in
                    if let document = document, document.exists {
                        let data = document.data()
                        product.productDetail = data!["detail"] as! String
                        product.productPrice = data!["price"] as! String
                        product.averageRate = data!["averageRate"] as! Double
                        product.timestamp = data!["timestamp"] as! Double
                        
                        let coreData = self.fetchProductsByName("\(product.productName)")
                        print("bbc\(product.productName)")
                        
                        var image1Data = Data()
                        var image2Data = Data()
                        var image3Data = Data()
                        
                        
                        if coreData .isEmpty {
                            print("Ürün coredatada yok eklenecek ")
                            let group2 = DispatchGroup()
                            group2.enter()
                            image1.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
                                if let error = error {
                                    print("Error downloading image: \(error.localizedDescription)")
                                    group2.leave()
                                } else {
                                    let image1 = UIImage(data: data!)
                                    product.image1 = image1!
                                    image1Data = data!
                                    group2.leave()
                                }
                             
                            }
                            
                            group2.enter()
                            image2.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
                                if let error = error {
                                    print("Error downloading image: \(error.localizedDescription)")
                                    group2.leave()
                                } else {
                                    let image2 = UIImage(data: data!)
                                    product.image2 = image2!
                                    image2Data = data!
                                    group2.leave()
                                }
                               
                            }
                            group2.enter()
                            image3.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
                                if let error = error {
                                    print("Error downloading image: \(error.localizedDescription)")
                                    group2.leave()
                                } else {
                                    let image3 = UIImage(data: data!)
                                    product.image3 = image3!
                                    image3Data = data!
                                    group2.leave()
                                }
                            }
                            group2.notify(queue: .main) {
                                // burada üç fotoğrafında gruoplar yardımıyla indiği vaarsayılacak
                                
                                //CoreDataya kaydetme
                                self.saveProduct(name: product.productName, detail: product.productDetail, category: product.productCategory, price: product.productPrice, rate: product.averageRate, timestamp: product.timestamp, image1: image1Data, image2: image2Data, image3: image3Data)
                                //Ürün arrayine kaydetme
                                productArray.append(productBrain(productCategory: product.productCategory, productName: product.productName, productDetail: product.productDetail, productPrice: product.productPrice, averageRate: product.averageRate, timestamp: product.timestamp, image1: product.image1, image2: product.image2, image3: product.image3))
                                self.productVariable += 1
                            }
                        }else{
                            if coreData[0].timestamp != product.timestamp{
                                print("İnternetteki veri daha güncel, ürün coredatadan silinip güncel veri indirilip coredatada  güncellenecek ve uygulamada gösterilecek")
                                print("silinecek\(coreData[0].timestamp)")
                                self.itemtobedeletedfromthearray.append(coreData[0].name!)
                                productArray = productArray.filter { !self.itemtobedeletedfromthearray.contains($0.productName) }
                                self.deleteProduct(timestamp: coreData[0].timestamp)
                                
                                
                                let group1 = DispatchGroup()
                                group1.enter()
                                image1.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
                                    if let error = error {
                                        print("Error downloading image: \(error.localizedDescription)")
                                        group1.leave()
                                    } else {
                                        let image1 = UIImage(data: data!)
                                        product.image1 = image1!
                                        image1Data = data!
                                        group1.leave()
                                    }
                                 
                                }
                                
                                group1.enter()
                                image2.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
                                    if let error = error {
                                        print("Error downloading image: \(error.localizedDescription)")
                                        group1.leave()
                                    } else {
                                        let image2 = UIImage(data: data!)
                                        product.image2 = image2!
                                        image2Data = data!
                                        group1.leave()
                                    }
                                   
                                }
                                group1.enter()
                                image3.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
                                    if let error = error {
                                        print("Error downloading image: \(error.localizedDescription)")
                                        group1.leave()
                                    } else {
                                        let image3 = UIImage(data: data!)
                                        product.image3 = image3!
                                        image3Data = data!
                                        group1.leave()
                                    }
                                }
                                group1.notify(queue: .main) {
                                    //CoreDataya kaydetme
                                    self.saveProduct(name: product.productName, detail: product.productDetail, category: product.productCategory, price: product.productPrice, rate: product.averageRate, timestamp: product.timestamp, image1: image1Data, image2: image2Data, image3: image3Data)
                                    //Ürün arrayine kaydetme
                                    productArray.append(productBrain(productCategory: product.productCategory, productName: product.productName, productDetail: product.productDetail, productPrice: product.productPrice, averageRate: product.averageRate, timestamp: product.timestamp, image1: product.image1, image2: product.image2, image3: product.image3))
                                    self.productVariable += 1
                                    self.getFavoritesData() {}
                                }
                            }

                        }
                        
                        
                    } else {
                        print("Document does not exist")
                    }
                    group.leave()
                }
                group.enter()
                let myDat = fetchProducts()
                var im1 = UIImage()
                var im2 = UIImage()
                var im3 = UIImage()
                
                for itm in myDat{
                    if let img1 = itm.image1 {
                        im1 = UIImage(data: img1) ?? UIImage(named: "logo")!
                    }else{
                        im1 = UIImage(named: "logo")!
                    }
                    if let img2 = itm.image2 {
                        im2 = UIImage(data: img2) ?? UIImage(named: "logo")!
                    }else{
                        im2 = UIImage(named: "logo")!
                    }
                    if let img3 = itm.image3 {
                        im3 = UIImage(data: img3) ?? UIImage(named: "logo")!
                    }else{
                        im3 = UIImage(named: "logo")!
                    }
                    let myArray = productBrain(productCategory: itm.category!, productName: itm.name!, productDetail: itm.detail!, productPrice: itm.price!, averageRate: itm.rate, timestamp: itm.timestamp, image1: im1, image2: im2, image3: im3)
                    if constant == 1 {
                        productArray.append(myArray)
                        self.productVariable += 1
                        constant = 0
                    }
                    var isDuplicate = false
                    for prdc in productArray{
                        if prdc.productName == myArray.productName{
                            isDuplicate = true
                            break
                        }
                    }
                    if !isDuplicate {
                        productArray.append(myArray)
                        self.productVariable += 1
                    }
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            completion()
        }
    }
    
    func getFavoritesData(completion: @escaping () -> Void){
        userFavorites = []
        self.db.collection("users").document(user!).collection("FavoriteProducts").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    for product in productArray{
                        if document.documentID == product.productName{
                            userFavorites.append(product)
                        }
                    }
                }
                var indexesToRemove: [Int] = []
                for index in 0..<userFavorites.count {
                    if userFavorites[index].productDetail == "" {
                        indexesToRemove.append(index)
                    }
                }
                for index in indexesToRemove.reversed() {
                    userFavorites.remove(at: index)
                }
            }
            completion()
        }
    }
    func fixCollectionViewData(completion: @escaping () -> Void) {
        var indexesToRemove: [Int] = []
        var nmbr = 0
        let finalNmbr = productArray.count
        for index in 0..<productArray.count {
            nmbr += 1
            if productArray[index].productDetail == "" {
                indexesToRemove.append(index)
            }
        }
        for index in indexesToRemove.reversed() {
            productArray.remove(at: index)
        }
        if nmbr == finalNmbr{
            completion()
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
    func fetchProductsByName(_ name: String) -> [Product] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Product>(entityName: "Product")
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let products = try context.fetch(fetchRequest)
            return products
        } catch {
            print("Error fetching products: \(error)")
            return []
        }
    }
    func deleteProduct(timestamp:Double) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")

        fetchRequest.predicate = NSPredicate(format: "timestamp == %@", timestamp as NSNumber)

        do {
          let results = try context.fetch(fetchRequest)
          for data in results {
              context.delete(data as! NSManagedObject)
          }
        } catch let error as NSError {
          print("Could not fetch data. \(error), \(error.userInfo)")
        }
        do {
          try context.save()
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func deleteProduct(name:String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")

        fetchRequest.predicate = NSPredicate(format: "name == %@", name)

        do {
          let results = try context.fetch(fetchRequest)
          for data in results {
              context.delete(data as! NSManagedObject)
          }
        } catch let error as NSError {
          print("Could not fetch data. \(error), \(error.userInfo)")
        }
        do {
          try context.save()
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func saveProduct(name: String,detail: String,category: String,price: String,rate: Double, timestamp: Double, image1: Data? = nil, image2: Data? = nil, image3: Data? = nil) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newProduct = NSEntityDescription.insertNewObject(forEntityName: "Product", into: context) as! Product
        
        newProduct.name = name
        newProduct.timestamp = timestamp
        newProduct.detail = detail
        newProduct.price = price
        newProduct.rate = rate
        newProduct.category = category
        if let imageData1 = image1 {
            newProduct.image1 = imageData1
        }
        if let imageData2 = image2 {
            newProduct.image2 = imageData2
        }
        if let imageData3 = image3 {
            newProduct.image3 = imageData3
        }
        
        do {
            try context.save()
            print("Product saved successfully")
        } catch {
            print("Error saving product: \(error)")
            context.rollback() // Revert any changes made during the save attempt
        }
    }

    func productDeletedByTheDeveloper(){
        self.db.collection("developer@gmail.com").document("productDeletedByTheDeveloper").collection("Deleted").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documen: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("docu\(document.documentID)")
                    self.deleteProduct(name: document.documentID)
                }
            }
        }
    }
    func fetchProducts() -> [Product] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Product>(entityName: "Product")
        
        do {
            let products = try context.fetch(fetchRequest)
            return products
        } catch {
            print("Error fetching products: \(error)")
            return []
        }
    }
    private func getListedProducts(){
        db.collection("developer@gmail.com").document("Listed-Non Listed Products").collection("ListedProducts").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let productId = document.documentID
                    listedProducts.append(productId)
                }
            }
        }
    }
    private func getNumberOfItems(){
        self.db.collection("developer@gmail.com").document("numberofitems").getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                self.numberOfProduct = data!["product"] as! Int
                self.numberOfCategory = data!["category"] as! Int
                print("numbb\(self.numberOfProduct)")
                print("numb\(self.numberOfCategory)")
            } else {
                print("Document does not exist")
            }
        }
    }
}

//func deleteAllProducts() {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//
//        do {
//            try context.execute(deleteRequest)
//        } catch {
//            print("Error deleting products: \(error)")
//        }
//    }
