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
    
    @IBOutlet var cityText: UITextField!
    @IBOutlet var surname: UITextField!
    @IBOutlet var titleText: UITextField!
    @IBOutlet var name: UITextField!
    @IBOutlet var phoneNumber: UITextField!
    @IBOutlet var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPicker()
        dissmissAndClosePickerView()
        textView.text = addresses[index].address
        titleText.text = addresses[index].title
        name.text = addresses[index].name
        surname.text = addresses[index].surname
        phoneNumber.text = addresses[index].phoneNumber
        cityText.text = addresses[index].city
        loadData()
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @IBAction func saveButton(_ sender: UIButton) {
        let address = self.textView.text
        let words = address!.split(separator: " ")
        let firstTwoWords = words.prefix(2)
        
        db.collection("users").document(user!).collection("address").document("\(firstTwoWords)").delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document removed")
            }
        }
        if address == self.textView.text , let phone = self.phoneNumber.text ,  let name = self.name.text , let surname = self.surname.text, let title = self.titleText.text {
            db.collection("users").document(user!).collection("address").document("\(firstTwoWords)").setData([
                "address": address!,
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
        addresses = []
        db.collection("users").document(user!).collection("address").getDocuments { (querySnapshot, error) in
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
        cityText.text = cityArray
        print(cityArray)
    }
    func dissmissAndClosePickerView(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let button = UIBarButtonItem(title: "Done", style: .plain,target: self,action: #selector(self.dissmissAction))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        self.cityText.inputAccessoryView = toolBar
    }
    @objc func dissmissAction(){
        self.view.endEditing(true)
    }
    func setupPicker(){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        cityText.inputView = pickerView
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
        if name.isFirstResponder {
            return
        }
        if surname.isFirstResponder {
            return
        }
        if phoneNumber.isFirstResponder {
            return
        }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


// uygulamada çok hızlı işlemler yapınca bu hatayı alıyorum




