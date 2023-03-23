//
//  DeveloperViewController.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 26.01.2023.
//



// Uzun vadeli güncelleme --> Fotoğrafların boyutu büyük, geri bildirim gönderirikenki yüklenen fotoğrafların boyutu küçültülecek.





import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import MBProgressHUD
class DeveloperViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    let storage = Storage.storage()
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser?.email
    var loadedItemCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoader()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        
        // burada uygulamanın internetten veri indirmesini beklemek için bekleme yuvarlağı konulacak
        categoryArray = []
        productArray = []
        getCategoryImage()
        getProductImage()
        feedbacks = []
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.fixCollectionView()
        }
        fetchData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DeveloperMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell" , for: indexPath) as! TableViewCell
        cell.label.text = DeveloperMenu[indexPath.row]
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
        if index == 3 {
            performSegue(withIdentifier: "developerToFeedBacks", sender: nil)
        }
    }
    func getCategoryImage(){
        for index in 0..<productCategories.count {
            let storageRef = self.storage.reference()
            let imagesRef = storageRef.child(user!)
            let images1Ref = imagesRef.child("Category")
            let images2Ref = images1Ref.child(productCategories[index])
            let images3Ref = images2Ref.child("categoryImage")
            
            images3Ref.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
                if let error = error {
                    print("Error downloading image: \(error.localizedDescription)")
                } else {
                    let image = UIImage(data: data!)
                    categoryArray.append(categorBrain(categoryName: productCategories[index], categoryImage: image!))
                }
            }
        }
    }
    func getProductImage(){
        // Product Categories içerisindeki kategoriler
        
        for index in 0..<productCategories.count {
            let storageRef = self.storage.reference()
            let imagesRef = storageRef.child(user!)
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
                        hideLoader()
                    }
                }
                db.collection(self.user!).document("Products").collection(productCategories[index]).document(products[item]).getDocument { (document, error) in
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
    
    //Feedbacks için verileri çekme
    private func fetchData() {
        var idArray = ["":""]
        idArray = [:]
        db.collection("Feedbacks").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    idArray["\(document.documentID)"] = "\(document.data().first!.key)"
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            for itm in idArray {
                self.db.collection("Feedbacks").document("\(itm.key)").collection("\(itm.value)").getDocuments { (querySnapshot, erro) in
                    if let erro = erro {
                        print("Error getting documents: \(erro)")
                    } else {
                        print("uu\(itm.key)oo\(itm.value)")
                        var newFeedbacks = [Feedback]()
                        for documents in querySnapshot!.documents {
                            var feedBackImage = UIImage(data: Data())
                            print("pğ\(feedBackImage)")
                            let storageRef = self.storage.reference()
                            let imagesRef = storageRef.child("Feedbacks")
                            let images1Ref = imagesRef.child("\(itm.key)")
                            let images2Ref = images1Ref.child("\(itm.value)")
                            print("burada başladı ")
                            images2Ref.getData(maxSize: 5 * 1024 * 1024) { data, error in
                                if let error = error {
                                    print("Eror :\(error)")
                                    feedBackImage = nil
                                    print("burada bitti error")
                                    if let timestampString = documents.data().keys.first,
                                        let timestamp = Double(timestampString) {
                                       let exampleFeedback = Feedback(userEmail: "\(itm.key)", timestamp: Date(timeIntervalSince1970: timestamp), text: documents.data()[timestampString] as! String, imageData:UIImage(named: "logo")! )
                                       newFeedbacks.append(exampleFeedback)
                                   }
                                } else {
                                    // Data for "images/island.jpg" is returned
                                    let image = UIImage(data: data!)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                                        feedBackImage = image
                                        print("pğ\(feedBackImage!)")
                                        print("burada bitti oldu")
                                        if let timestampString = documents.data().keys.first,
                                           let timestamp = Double(timestampString) {
                                            let exampleFeedback = Feedback(userEmail: "\(itm.key)", timestamp: Date(timeIntervalSince1970: timestamp), text: documents.data()[timestampString] as! String, imageData: feedBackImage!)
                                            newFeedbacks.append(exampleFeedback)
                                            print("yy\(feedBackImage!)")
                                            feedBackImage = UIImage(data: Data())
                                        }
                                    }
                                }
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
                            // Garantiye almak için 5 saniye eklendi azaltılabilir.(Fotoğrafların boyutu büyük olduğu için
                            print("Gir")
                            feedbacks += newFeedbacks
                        }
                    }
                }
            }
        }
    }
}
