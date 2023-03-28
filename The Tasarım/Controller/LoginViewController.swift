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
import GoogleSignIn
class LoginViewController: UIViewController {
    
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var signUpButtonOutlet: UIButton!
    @IBOutlet var signInButtonOutlet: UIButton!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = Auth.auth().currentUser?.email
        if let user1 = user {
            print("User\(user1)")
            performSegue(withIdentifier: "loginToLaunch", sender: nil)
        }
        
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
        addSignInButton()
    }
    
    @IBAction func signInButton(_ sender: UIButton) {
        if let email = emailTextField.text , let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in if let e = error {
                print(e)
            } else {
                self.navigateToViewController()
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
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
            let userEmail = user.profile?.email
            checkIfUserExists(email: userEmail!) { exists in
                if exists {
                    let credential = GoogleAuthProvider.credential(withIDToken: idToken,accessToken: user.accessToken.tokenString)
                    Auth.auth().signIn(with: credential) { result, error in
                        self.navigateToViewController()
                    }
                } else {
                    print("Kullanıcı önceden kayıtlı değil.")
                    self.navigateToRegisterViewController()
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
            signInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.height / 4)
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
    func navigateToRegisterViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let navigationController = self.navigationController {
            let viewController = storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
            navigationController.pushViewController(viewController, animated: true)
        } else {
            print("Navigation controller not found")
        }
    }
}
