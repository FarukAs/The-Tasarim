//
//  AdressViewController.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 27.01.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
class AddressViewController: UIViewController , UICollectionViewDelegate,UICollectionViewDataSource {
    
 

    @IBOutlet var collectionView: UICollectionView!
    
    
    var reloadCollectionView: (() -> Void)?
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser?.email
    let userID = Auth.auth().currentUser?.uid
    var selectedIndex = 0
    var editAddress = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        UsersAddress = []
        addresses = []
        loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name("ReloadCollectionView"), object: nil)
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddressReusableCell", for: indexPath as IndexPath) as! AddressCollectionViewCell
        
        
        cell.titleLabel.text = addresses[indexPath.item].title
        cell.contentLabel.text = "\(addresses[indexPath.item].address) \(addresses[indexPath.item].city)"
        
        
        
        
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.cornerRadius = 10.0
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOffset = CGSize(width: 2, height: 2)
        cell.layer.shadowColor = UIColor.darkGray.cgColor
        
        cell.deleteButton.addTarget(self, action: #selector(deleteItem), for: .touchUpInside)
        cell.deleteButton.tag = indexPath.item
        
        cell.editButton.addTarget(self, action: #selector(editItem), for: .touchUpInside)
        cell.editButton.tag = indexPath.item
        
        return cell
    }
    
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func loadData() {
        db.collection(user!).document("address").collection(userID!).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let address = UserAddress(address: data["address"] as! String, city: data["city"] as! String, name: data["name"] as! String, surname: data["surname"] as! String, phoneNumber: data["phoneNumber"] as! String, title: data["title"] as! String)
                    addresses.append(address)
                    self.reloadData()
                }
            }
        }
    }
    @objc func reloadData() {
        collectionView.reloadData()
      }
    deinit {
        NotificationCenter.default.removeObserver(self)
      }
    
    // Adres silme
    
    @objc func deleteItem(sender: UIButton) {
        
        let alert = UIAlertController(title: "Adres Silinecek...", message: "Adresi silmeyi onaylıyor musunuz?", preferredStyle: UIAlertController.Style.alert)
        let cancelButton = UIAlertAction(title: "Vazgeç", style: UIAlertAction.Style.cancel, handler: nil)
        let okButton = UIAlertAction(title: "Onayla", style: UIAlertAction.Style.default) { [self]  UIAlertAction in
            let indexPath = IndexPath(item: sender.tag, section: 0)
            let index = indexPath.item
            db.collection(user!).document("address").collection(userID!).document("\(addresses[index].address)").delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document removed")
                }
            }
            addresses = []
            loadData()
        }
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func editItem(sender: UIButton) {
        let indexPath = IndexPath(item: sender.tag, section: 0)
        let index = indexPath.item
        selectedIndex = index
        editAddress = addresses[index].address
        self.performSegue(withIdentifier: "addressToEdit", sender: nil)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "addressToEdit" {
                let destinationVC = segue.destination as! EditViewController
                destinationVC.index = self.selectedIndex
                destinationVC.newAddress = editAddress
            }
    }
}
