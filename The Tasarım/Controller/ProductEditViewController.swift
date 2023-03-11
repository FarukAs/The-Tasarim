//
//  ProductEditViewController.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 14.02.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
class ProductEditViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    @IBOutlet var categoryCollectionView: UICollectionView!
    @IBOutlet var collectionView: UICollectionView!
    let storage = Storage.storage()
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser?.email
    var selectedProduct = 0
    var selectedCategory = categoryArray[0].categoryName
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryClicked()
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView{
            return collectionViewData.count
        }else{
            return categoryArray.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView{
            selectedItem = indexPath.item
            performSegue(withIdentifier: "ProductEditToEdit1", sender: nil)
            
        }else{
            selectedCategory = categoryArray[indexPath.item].categoryName
            categoryClicked()
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditProductReusableCell", for: indexPath as IndexPath) as! EditProductCollectionViewCell
            cell.imageView.image = collectionViewData[indexPath.item].image1
            cell.productName.text = collectionViewData[indexPath.item].productName
            cell.productPrice.text = "\(collectionViewData[indexPath.item].productPrice) TL"
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditCategoryReusableCell", for: indexPath as IndexPath) as! EditCategoryCollectionViewCell
            cell.categoryTitle.text = categoryArray[indexPath.item].categoryName
            cell.imageView.image = categoryArray[indexPath.item].categoryImage
            return cell
        }
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Ne eklemek istersin", message: "Categori veya ürün seç", preferredStyle: UIAlertController.Style.alert)
        let category = UIAlertAction(title: "Kategori Ekle", style: UIAlertAction.Style.default) { [self]  UIAlertAction in
            performSegue(withIdentifier: "productEditToAddCategory", sender: nil)
        }
        let product = UIAlertAction(title: "Ürün Ekle", style: UIAlertAction.Style.default) { [self]  UIAlertAction in
            performSegue(withIdentifier: "productEditToAddProduct", sender: nil)
        }
        alert.addAction(category)
        alert.addAction(product)
        self.present(alert, animated: true, completion: nil)
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
