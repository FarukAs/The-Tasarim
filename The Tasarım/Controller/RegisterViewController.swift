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
import GoogleSignIn
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
        addSignInButton()
    }
    
    
    @IBAction func signUpButton(_ sender: UIButton) {
        if  let name = self.nameTextField.text , let surname = surnameTextField.text , let phoneNumber = phoneNumberTextField.text,let email = emailTextField.text , let password = passwordTextField.text  {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print("error...\(e.localizedDescription)")
                    if e.localizedDescription == "The email address is already in use by another account." {
                        // Kullanıcı zaten kayıtlı
                        let alert = UIAlertController(title: "Maile kayıtlı hesap var", message: "Kullanıcı girişi sayfasına yönlendiriliyorsunuz", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Onayla", style: .default) { _ in
                            self.navigateToLoginViewController()
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                } else {
                    User = []
                    let user1 = UserInfo(name: name, surname: surname, phoneNumber: phoneNumber, email: email)
               
                    self.db.collection("users").document("\(email)").collection("userInfo").document("Info").setData(user1.toDictionary()) { (error) in
                        if let error = error {
                            print("Error adding user: \(error)")
                        } else {
                            print("User added successfully!")
                            self.navigateToViewController()
                        }
                    }
                    self.db.collection("users").document(email).collection("Coupons").document("NumberOfCoupons").setData(["number" : 0])
                    
                    self.db.collection("users").document(email).setData(["name" : name,"surname":surname,"phoneNumber": phoneNumber,"email":email,"address": "","addressTitle": "","city": "" ])
                    td_currentuser = UserDefaultsKeys(givenName: name , familyName: surname, email: email, phoneNumber: phoneNumber)
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
                self.view.frame.origin.y -= keyboardSize.height / 2
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    func signInGoogle(){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {
                print("error")
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                print("success")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,accessToken: user.accessToken.tokenString)
            let userEmail = user.profile?.email
            checkIfUserExists(email: userEmail!) { exists in
                if exists {
                        // Kullanıcı zaten kayıtlı
                        let alert = UIAlertController(title: "Maile kayıtlı hesap var", message: "Kullanıcı girişi sayfasına yönlendiriliyorsunuz", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Onayla", style: .default) { _ in
                            self.navigateToLoginViewController()
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                } else {
                    print("Kullanıcı önceden kayıtlı değil.")
                    Auth.auth().signIn(with: credential) { result, error in
                        
                        let ugivenName = user.profile?.givenName
                        let ufamilyName = user.profile?.familyName
                        var uemail = ""
                        let user1 = Auth.auth().currentUser
                        if let user = user1 {
                            uemail = user.email!
                        }
                        let user2 = UserInfo(name: ugivenName!, surname: ufamilyName!, phoneNumber: "", email: uemail)
                        
                        self.db.collection("users").document("\(uemail)").collection("userInfo").document("Info").setData(user2.toDictionary()) { (error) in
                            if let error = error {
                                print("Error adding user: \(error)")
                            } else {
                                print("User added successfully!")
                            }
                        }
                        self.db.collection("users").document(uemail).collection("Coupons").document("NumberOfCoupons").setData(["number" : 0])
                        self.db.collection("users").document(uemail).setData(["name" : ugivenName,"surname": ufamilyName,"phoneNumber": "","email":uemail,"address": "","addressTitle": "","city": ""])
                        
                        td_currentuser = UserDefaultsKeys(givenName: ugivenName! , familyName: ufamilyName!, email: uemail, phoneNumber: "")
                        self.navigateToViewController()
                    }
                }
            }
        }
    }
    func checkIfUserExists(email: String, completion: @escaping (Bool) -> Void) {
        let usersRef = db.collection("users")
        let query = usersRef.whereField("email", isEqualTo: email)
        
        query.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error checking if user exists: \(error)")
                completion(false)
            } else {
                if snapshot!.documents.count > 0 {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    func addSignInButton(){
        let signInButton = GIDSignInButton()
        signInButton.style = .wide
        signInButton.colorScheme = .dark
        view.addSubview(signInButton)
        
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.height / 6)
        ])
        
        signInButton.addTarget(self, action: #selector(googleSignInTapped), for: .touchUpInside)
    }
    @objc func googleSignInTapped() {
        signInGoogle()
    }
    func navigateToViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let navigationController = self.navigationController {
            let viewController = storyboard.instantiateViewController(withIdentifier: "LaunchScreenViewController") as! LaunchScreenViewController
            navigationController.pushViewController(viewController, animated: true)
        } else {
            print("Navigation controller not found")
        }
    }
    func navigateToLoginViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let navigationController = self.navigationController {
            let viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            navigationController.pushViewController(viewController, animated: true)
        } else {
            print("Navigation controller not found")
        }
    }
}
