//
//  CouponViewController.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 10.02.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
class CouponViewController: UIViewController , UICollectionViewDelegate,UICollectionViewDataSource {
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser?.email
    let userID = Auth.auth().currentUser?.uid
    @IBOutlet var numberOfCoupons: UILabel!
    @IBOutlet var earnCoupons: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        layoutsOfButtons()
        numberOfCoupons.text = "Kuponlar(\(numberOfData))"
    }
    
    @objc func useCoupon(sender: UIButton) {
        print("Kupon Kullanıldı.(Kullanıcı Sepete gönderilecek)")
    }
    func useButtonLayout(useCoupon : UIButton){
        useCoupon.layer.borderWidth = 1.0
        useCoupon.layer.borderColor = UIColor.lightGray.cgColor
        useCoupon.layer.cornerRadius = 10.0
        useCoupon.layer.shadowOpacity = 0.5
        useCoupon.layer.shadowRadius = 2.0
        useCoupon.layer.shadowOffset = CGSize(width: 2, height: 2)
        useCoupon.layer.shadowColor = UIColor.darkGray.cgColor
        useCoupon.backgroundColor = .orange
    }
    func layoutsOfButtons(){
        earnCoupons.layer.borderWidth = 1.0
        earnCoupons.layer.borderColor = UIColor.lightGray.cgColor
        earnCoupons.layer.cornerRadius = 10.0
        earnCoupons.layer.shadowOpacity = 0.5
        earnCoupons.layer.shadowRadius = 2.0
        earnCoupons.layer.shadowOffset = CGSize(width: 2, height: 2)
        earnCoupons.layer.shadowColor = UIColor.darkGray.cgColor
        numberOfCoupons.layer.borderWidth = 1.0
        numberOfCoupons.layer.borderColor = UIColor.lightGray.cgColor
        numberOfCoupons.layer.cornerRadius = 10.0
        numberOfCoupons.layer.shadowOpacity = 0.5
        numberOfCoupons.layer.shadowOffset = CGSize(width: 2, height: 2)
        numberOfCoupons.layer.shadowColor = UIColor.darkGray.cgColor
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfData
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddressReusableCell", for: indexPath as IndexPath) as! CouponCollectionViewCell
        
        cell.useCoupon.addTarget(self, action: #selector(useCoupon), for: .touchUpInside)
        cell.useCoupon.tag = indexPath.item
        useButtonLayout(useCoupon: cell.useCoupon)
        
        
        
        cell.category.text = coupon[indexPath.item].category
        cell.limit.text = coupon[indexPath.item].limit
        cell.price.text = coupon[indexPath.item].price
        return cell
    }
    
}
