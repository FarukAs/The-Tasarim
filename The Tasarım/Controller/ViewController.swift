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
class ViewController: UIViewController , UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate {
    
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
        categoryClicked()
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
            print("selected")
        }else{
            selectedCategory = categoryArray[indexPath.item].categoryName
            categoryClicked()
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "ProductReusableCell", for: indexPath as IndexPath) as! ProductCollectionViewCell
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
            let productImages = [
                collectionViewData[indexPath.item].image1,
                collectionViewData[indexPath.item].image2,
                collectionViewData[indexPath.item].image3
            ]
            let images = [collectionViewData[indexPath.item].image1, collectionViewData[indexPath.item].image2, collectionViewData[indexPath.item].image3]
            cell.configure(images: images)
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
}
