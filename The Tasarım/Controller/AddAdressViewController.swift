//
//  AddAdressViewController.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 27.01.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
class AddAdressViewController: UIViewController ,UIPickerViewDelegate,UIPickerViewDataSource {
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser?.email
    var cityArray = ""
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
        
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        
        if let adres = textView.text , let phone = phoneNumber.text ,  let name1 = name.text , let surname1 = surname.text, let title1 = titleText.text {
            self.db.collection("users").document(user!).setData(["address" : adres ,"phoneNumber":phone, "name": "\(name1)\(surname1)","city":cityArray, "title": title1]) { (error) in
                if let error = error {
                    print("Error adding user: \(error)")
                } else {
                    print("User added successfully!")
                }
            }
        } else {
            let alert = UIAlertController(title: "Hata", message: "Lütfen tüm alanları doldurunuz.", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
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
    }
}

