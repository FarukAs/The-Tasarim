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
class ViewController: UIViewController , UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet var categoryCollectionView: UICollectionView!
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var accountStackView: UIStackView!
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser?.email
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        accountStackView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToLogin))
        accountStackView.addGestureRecognizer(tapGesture)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return 10
        }else{
            return 10
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "ProductReusableCell", for: indexPath as IndexPath) as! ProductCollectionViewCell
           
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryReusableCell", for: indexPath as IndexPath) as! CategoryCollectionViewCell
           
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
    
}
