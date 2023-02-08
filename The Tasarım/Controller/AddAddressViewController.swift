//
//  AddAddressViewController.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 27.01.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
class AddAddressViewController: UIViewController ,UIPickerViewDelegate,UIPickerViewDataSource {
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser?.email
    let userID = Auth.auth().currentUser?.uid
    var cityArray = ""
    let ref = Database.database().reference().child("address")
    let addressVC = AddressViewController()
    @IBOutlet var titleText: UITextField!
    @IBOutlet var picker: UIPickerView!
    @IBOutlet var textView: UITextView!
    @IBOutlet var phoneNumber: UITextField!
    @IBOutlet var surname: UITextField!
    @IBOutlet var name: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        navigationItem.title = "Adres Ekle"
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        
        if let adres = self.textView.text , let phone = self.phoneNumber.text ,  let name = self.name.text , let surname = self.surname.text, let title = self.titleText.text {
            db.collection(user!).document("address").collection(userID!).document(adres).setData([
                "address": adres,
                "city": cityArray,
                "name": "\(name) \(surname)",
                "phoneNumber": phone,
                "title": title
            ]) { (error) in
                if let error = error {
                    print("Error adding document: \(error)")
                } else {
                    print("Document added successfully")
                    self.loadData()
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
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
    }
    func loadData() {
        addresses = []
        db.collection(user!).document("address").collection(userID!).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let address = UserAddress(address: data["address"] as! String, city: data["city"] as! String, name: data["name"] as! String, phoneNumber: data["phoneNumber"] as! String, title: data["title"] as! String)
                    addresses.append(address)
                    NotificationCenter.default.post(name: NSNotification.Name("ReloadCollectionView"), object: nil)
                        self.dismiss(animated: true)
                }
            }
        }
    }
}

