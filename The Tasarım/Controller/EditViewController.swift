//
//  EditViewController.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 8.02.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
class EditViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    var index = 0
    var newAddress = ""
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser?.email
    let userID = Auth.auth().currentUser?.uid
    var cityArray = ""
    @IBOutlet var picker: UIPickerView!
    @IBOutlet var surname: UITextField!
    @IBOutlet var titleText: UITextField!
    @IBOutlet var name: UITextField!
    @IBOutlet var phoneNumber: UITextField!
    @IBOutlet var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        loadData()
        print(index)
        textView.text = addresses[index].address
        titleText.text = addresses[index].title
        name.text = addresses[index].name
        surname.text = addresses[index].surname
        
    
        
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        
        db.collection(user!).document("address").collection(userID!).document("\(addresses[index].address)").delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document removed")
            }
        }
        
        
        if let adres = self.textView.text , let phone = self.phoneNumber.text ,  let name = self.name.text , let surname = self.surname.text, let title = self.titleText.text {
            db.collection(user!).document("address").collection(userID!).document(adres).setData([
                "address": adres,
                "city": cityArray,
                "name": name,
                "surname": surname,
                "phoneNumber": phone,
                "title": title
            ]) { (error) in
                if let error = error {
                    print("Error adding document: \(error)")
                } else {
                    print("Document added successfully")
                    addresses = []
                    self.loadData()
                    self.dismiss(animated: true)
                }
            }
        }

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
                    NotificationCenter.default.post(name: NSNotification.Name("ReloadCollectionView"), object: nil)
                        
                }
            }
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return city.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return city[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cityArray = city[row]
        print(cityArray)
    }
}
