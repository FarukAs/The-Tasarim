//
//  RegisterViewController.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 26.01.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
class RegisterViewController: UIViewController , UITextFieldDelegate {
    
    @IBOutlet var signUpButtonOutlet: UIButton!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var surnameTextField: UITextField!
    @IBOutlet var phoneNumberTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        surnameTextField.delegate = self
        phoneNumberTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        hideKeyboardWhenTappedAround()
        signUpButtonOutlet.layer.cornerRadius = 18
        signUpButtonOutlet.layer.shadowColor = UIColor.black.cgColor
        signUpButtonOutlet.layer.shadowOffset = CGSize(width: 5, height: 5)
        signUpButtonOutlet.layer.shadowRadius = 10
        signUpButtonOutlet.layer.shadowOpacity = 0.3
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @IBAction func signUpButton(_ sender: UIButton) {
        if  let name = self.nameTextField.text , let surname = surnameTextField.text , let phoneNumber = phoneNumberTextField.text,let email = emailTextField.text , let password = passwordTextField.text  {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                } else {
                    User = []
                    let user1 = UserInfo(name: name, surname: surname, phoneNumber: phoneNumber, email: email)

                    self.db.collection(email).document("userInfo").setData(user1.toDictionary()) { (error) in
                        if let error = error {
                            print("Error adding user: \(error)")
                        } else {
                            print("User added successfully!")
                            self.performSegue(withIdentifier: "registerToAccount", sender: nil)
                        }
                    }
                    self.db.collection(email).document("NumberOfCoupons").setData(["number" : 0])
                    
                }
            }
        }
        
        
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
}
