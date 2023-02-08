//
//  LoginViewController.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 26.01.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
class LoginViewController: UIViewController {

    @IBOutlet var signUpButtonOutlet: UIButton!
    @IBOutlet var signInButtonOutlet: UIButton!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        signInButtonOutlet.layer.cornerRadius = 18
        signInButtonOutlet.layer.shadowColor = UIColor.black.cgColor
        signInButtonOutlet.layer.shadowOffset = CGSize(width: 5, height: 5)
        signInButtonOutlet.layer.shadowRadius = 10
        signInButtonOutlet.layer.shadowOpacity = 0.3
        signUpButtonOutlet.layer.cornerRadius = 18
        signUpButtonOutlet.layer.shadowColor = UIColor.black.cgColor
        signUpButtonOutlet.layer.shadowOffset = CGSize(width: 5, height: 5)
        signUpButtonOutlet.layer.shadowRadius = 10
        signUpButtonOutlet.layer.shadowOpacity = 0.3
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func signInButton(_ sender: UIButton) {
        if let email = emailTextField.text , let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in if let e = error {
                print(e)
            } else {
                self.performSegue(withIdentifier: "loginToAccount", sender: nil)
                return
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
