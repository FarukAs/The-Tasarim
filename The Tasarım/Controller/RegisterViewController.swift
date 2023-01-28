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
    }
    
    
    @IBAction func signUpButton(_ sender: UIButton) {
        if  let name = self.nameTextField.text , let surname = surnameTextField.text , let phoneNumber = phoneNumberTextField.text,let email = emailTextField.text , let password = passwordTextField.text  {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                } else {
                    User = []
                    let user1 = UserInfo(name: name, surname: surname, phoneNumber: phoneNumber, email: email)

                    self.db.collection("users").document(email).setData(user1.toDictionary()) { (error) in
                        if let error = error {
                            print("Error adding user: \(error)")
                        } else {
                            print("User added successfully!")
                            self.performSegue(withIdentifier: "registerToAccount", sender: nil)
                        }
                    }
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
}
