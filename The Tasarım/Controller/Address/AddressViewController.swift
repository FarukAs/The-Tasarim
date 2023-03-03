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
    
    
    @IBOutlet var currentAddressView: UIView!
    @IBOutlet var currentAddressTitle: UILabel!
    @IBOutlet var currentAddress: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    
    var reloadCollectionView: (() -> Void)?
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser?.email
    let userID = Auth.auth().currentUser?.uid
    var selectedIndex = 0
    var editAddress = ""
    var currAddress = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        currentAddressViewLayout()
        loadCurrentAddress()
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentAddressTitle.text = addresses[indexPath.item].title
        currentAddress.text = "\(addresses[indexPath.item].address) \(addresses[indexPath.item].city)"
        
        // mevcut adresi databaseye kaydet
        db.collection(user!).document("TD_current_Address").setData([
            "address": addresses[indexPath.item].address,
            "city": addresses[indexPath.item].city,
            "name": addresses[indexPath.item].name,
            "surname": addresses[indexPath.item].surname,
            "phoneNumber": addresses[indexPath.item].phoneNumber,
            "title": addresses[indexPath.item].title
        ]) { (error) in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully")
                self.currAddress = addresses[indexPath.item].address
                
            }
        }
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
        let indexPath = IndexPath(item: sender.tag, section: 0)
        let index = indexPath.item
        
        let alert = UIAlertController(title: "Adres Silinecek...", message: "Adresi silmeyi onaylıyor musunuz?", preferredStyle: UIAlertController.Style.alert)
        let cancelButton = UIAlertAction(title: "Vazgeç", style: UIAlertAction.Style.cancel, handler: nil)
        let okButton = UIAlertAction(title: "Onayla", style: UIAlertAction.Style.default) { [self]  UIAlertAction in
            let address = addresses[index].address
            let words = address.split(separator: " ")
            let firstTwoWords = words.prefix(2)
            
            db.collection(user!).document("address").collection(userID!).document("\(firstTwoWords)").delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document removed")
                    // Silinen adres mevcut adres ise mevcut adres viewi boşaltılır
                    if  addresses[index].address == self.currAddress {
                        self.currentAddressTitle.text = "Mevcut adres yok"
                        self.currentAddress.text = ""
                        self.db.collection(self.user!).document("TD_current_Address").delete() { err in
                            if let err = err {
                                print("Error removing document: \(err)")
                            }
                        }
                    }
                    addresses = []
                    self.loadData()
                    self.reloadData()
                }
            }
            
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
    func currentAddressViewLayout(){
        currentAddressView.layer.borderWidth = 1.0
        currentAddressView.layer.borderColor = UIColor.lightGray.cgColor
        currentAddressView.layer.cornerRadius = 10.0
        currentAddressView.layer.shadowOpacity = 0.5
        currentAddressView.layer.shadowRadius = 2.0
        currentAddressView.layer.shadowOffset = CGSize(width: 2, height: 2)
        currentAddressView.layer.shadowColor = UIColor.darkGray.cgColor
    }
    
    // Uygulama açıldığında mevcut adres kısmının databaseden veri çekilerek doldurulması
    func loadCurrentAddress(){
        let docRef = db.collection(user!).document("TD_current_Address")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let address = UserAddress(address: data!["address"] as! String, city: data!["city"] as! String, name: data!["name"] as! String, surname: data!["surname"] as! String, phoneNumber: data!["phoneNumber"] as! String, title: data!["title"] as! String)
                self.currentAddressTitle.text = address.title
                self.currentAddress.text = "\(address.address) \(address.city)"
                self.currAddress = address.address
            } else {
                print("Document does not exist")
            }
        }
    }
    
}
