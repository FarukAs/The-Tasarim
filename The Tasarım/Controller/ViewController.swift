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
import CoreData
import Lottie
class ViewController: UIViewController , UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate {
    
    let animationView = LottieAnimationView()
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var mainMenuStackView: UIStackView!
    @IBOutlet var categoryCollectionView: UICollectionView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var favoritesStackView: UIStackView!
    @IBOutlet var accountStackView: UIStackView!
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser?.email
    let storage = Storage.storage()
    var selectedCategory = categoryArray[0].categoryName
    var selectedIndex = Int()
    var average = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setListedProducts()
        searchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        accountStackView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToLogin))
        accountStackView.addGestureRecognizer(tapGesture)
        let favtapGesture = UITapGestureRecognizer(target: self, action: #selector(goToFavorites))
        favoritesStackView.addGestureRecognizer(favtapGesture)
        let maintapGesture = UITapGestureRecognizer(target: self, action: #selector(mainMenu))
        mainMenuStackView.addGestureRecognizer(maintapGesture)
        
        
        collectionViewData.sort { (product1, product2) -> Bool in
            return product1.productName.localizedCaseInsensitiveCompare(product2.productName) == .orderedAscending
        }
        categoryClicked()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.categoryClicked()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.categoryClicked()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.categoryClicked()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.categoryClicked()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            self.categoryClicked()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 15.0) {
            self.categoryClicked()
        }
        
        
        let animationView = LottieAnimationView(name: "rocket")
        animationView.frame = CGRect(x: view.frame.width - 78, y: 500, width: 80, height: 160)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.clipsToBounds = true
        animationView.layer.cornerRadius = 25
        view.addSubview(animationView)
        
        let angle = CGFloat.pi / 2
        animationView.transform = CGAffineTransform(rotationAngle: angle)
        
        animationView.play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            categoryClicked()
        } else {
            filterProducts(searchText: searchText)
        }
    }
    func filterProducts(searchText: String) {
        collectionViewData = productArray.filter { (product) -> Bool in
            return product.productName.lowercased().contains(searchText.lowercased())
        }
        collectionView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
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
            showLoader()
            selectedIndex = indexPath.item
            getCommendData {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.performSegue(withIdentifier: "mainToProductView", sender: nil)
                    self.hideLoader()
                }
            }
        }else{
            selectedCategory = categoryArray[indexPath.item].categoryName
            categoryClicked()
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "ProductReusableCell", for: indexPath as IndexPath) as! ProductCollectionViewCell
            cell.pageControl.currentPage = 0
            cell.likeButton.addTarget(self, action: #selector(likeButton), for: .touchUpInside)
            cell.likeButton.tag = indexPath.item
            
            cell.layer.cornerRadius = 8.0
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 5, height: 5)
            cell.layer.shadowRadius = 8.0
            cell.layer.shadowOpacity = 0.5
            cell.layer.masksToBounds = false
            cell.backgroundColor = .white
            
            var isProductFavorite = false
            for fav in userFavorites {
                if collectionViewData[indexPath.item].productName == fav.productName {
                    isProductFavorite = true
                    break
                }
            }
            if isProductFavorite {
                cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
            let images = [collectionViewData[indexPath.item].image1, collectionViewData[indexPath.item].image2, collectionViewData[indexPath.item].image3]
            cell.configure(images: images)
            cell.indexPath = indexPath // Hücrenin indexPath'ini atayın
            cell.tapAction = { [weak self] indexPath in
                // Tıklama işlemi olduğunda çağrılacak işlevi atayın
                self?.collectionView(collectionView, didSelectItemAt: indexPath)
            }
            cell.averageRate.text = String(format: "%.1f", collectionViewData[indexPath.item].averageRate)
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
    @objc func mainMenu(){
        categoryCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
    @objc func goToFavorites() {
        performSegue(withIdentifier: "mainToFavorites", sender: nil)
    }
    @objc func goToLogin() {
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "mainToAccount", sender: nil)
        } else {
            performSegue(withIdentifier: "mainToLogin", sender: nil)
        }
    }
    @objc func likeButton(sender: UIButton) {
        print("asa\(listedProducts)")
        let index = sender.tag
        if sender.currentImage == UIImage(systemName: "heart.fill") {
            db.collection("users").document(user!).collection("FavoriteProducts").document("\(collectionViewData[index].productName)").delete()
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
            
            if let productIndex = userFavorites.firstIndex(where: { $0.productName == collectionViewData[index].productName }) {
                userFavorites.remove(at: productIndex)
            }
        } else {
            db.collection("users").document(user!).collection("FavoriteProducts").document("\(collectionViewData[index].productName)").setData(["String" : "String"])
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            userFavorites.append(collectionViewData[index])
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? ProductViewController {
            detailVC.selectedIndex = self.selectedIndex
            detailVC.average = average
        }
    }
    func showLoader() {
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
    func categoryClicked(){
        collectionViewData = []
        for prdct in productArray{
            if prdct.productCategory == selectedCategory{
                collectionViewData.append(prdct)
            }
        }
        collectionView.reloadData()
    }
    private func setListedProducts(){
        productArray = productArray.filter { listedProducts.contains($0.productName) }
        userFavorites = userFavorites.filter { listedProducts.contains($0.productName) }
    }
    func getCommendData(completion: @escaping () -> Void) {
        self.db.collection("developer@gmail.com").document("Products").collection(collectionViewData[selectedIndex].productCategory).document(collectionViewData[selectedIndex].productName).collection("Comments").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let data = document.data()
                    if let comment = data["Comment"] as? String ,let date = data["Date"] as? Int , let name = data["Name"] as? String, let rate = data["Rate"] as? Double , let id = data["Documentid"] as? String{
                        let cmmnt = commentBrain(Comment: comment, Date: Double(date), Rate: Double(rate), Name: name,Documentid: id)
                        commentsBrain.append(cmmnt)
                        self.getAverageRateData(){
                        }
                    }
                }
            }
            completion()
        }
    }
    private func getAverageRateData(completion: @escaping () -> Void) {
        var usersArray = [""]
        var rates = [0]
        usersArray = []
        rates = []
        self.db.collection("developer@gmail.com").document("Products").collection(collectionViewData[selectedIndex].productCategory).document(collectionViewData[selectedIndex].productName).collection("Comments").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    usersArray.append(document.documentID)
                }
                let group = DispatchGroup()
                for usr in usersArray {
                    self.db.collection("developer@gmail.com").document("Products").collection(collectionViewData[self.selectedIndex].productCategory).document(collectionViewData[self.selectedIndex].productName).collection("Comments").document(usr).getDocument(source: .cache) { (document, error) in
                        if let document = document {
                            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                            let data = document.data()
                            rates.append(data!["Rate"] as! Int)
                            if rates.count == usersArray.count {
                                self.average = Double(rates.reduce(0, +)) / Double(rates.count)
                                completion()
                            }
                        } else {
                            print("Document does not exist in cache")
                        }
                    }
                }
            }
        }
    }
}
