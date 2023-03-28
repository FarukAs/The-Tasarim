//
//  MyAccountViewController.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 27.03.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
class MyAccountViewController: UIViewController ,UITextFieldDelegate {
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser?.email
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Hesabınızı Güncelleyin"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let firstNameLabel: UILabel = {
        let label = UILabel()
        label.text = "İsim"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "İsim"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let lastNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Soyisim"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Soyisim"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.text = "Telefon"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Telefon Numarası"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .phonePad
        return textField
    }()
    
    private let dobLabel: UILabel = {
        let label = UILabel()
        label.text = "Doğum Tarihi"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let dobPicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        return datePicker
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "E-posta"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "E-posta Adresi"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.text = "Cinsiyet"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let genderSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Erkek", "Kadın"])
        return segmentedControl
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Kaydet", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private var userFirstName: String = ""
    private var userLastName: String = ""
    private var userPhoneNumber: String = ""
    private var userBirthDate: Date = Date()
    private var userGender: String = ""
    private var userEmail: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Hesabım"
        setupScrollView()
        setupLayout()
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        getFirstData()
        
        phoneTextField.delegate = self
        phoneTextField.text = "+90"
    }
    
    @objc private func saveButtonTapped() {
        userFirstName = firstNameTextField.text ?? ""
        userLastName = lastNameTextField.text ?? ""
        userPhoneNumber = phoneTextField.text ?? ""
        userEmail = emailTextField.text ?? ""
        userBirthDate = dobPicker.date
        userGender = genderSegmentedControl.selectedSegmentIndex == 0 ? "Erkek" : "Kadın"
        self.db.collection("users").document(user!).collection("userInfo").document("Info").setData(["name" : userFirstName,"surname": userLastName,"phoneNumber": userPhoneNumber,"birthDate": userBirthDate,"gender": userGender,"email": userEmail]) { (error) in
            if let error = error {
                print("Error adding user: \(error)")
            } else {
                print("User added successfully!")
                let alert = UIAlertController(title: "Başarılı", message: "Hesap bilgilerin güncellendi.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    func getFirstData(){
        let docRef = db.collection("users").document(user!).collection("userInfo").document("Info")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let user = UserInfo(name: data!["name"] as! String,
                                    surname: data!["surname"] as! String,
                                    phoneNumber: data!["phoneNumber"] as! String,
                                    email: data!["email"] as! String)
                if let gender = data!["gender"] as? String {
                    switch gender {
                    case "Erkek":
                        self.genderSegmentedControl.selectedSegmentIndex = 0
                    case "Kadın":
                        self.genderSegmentedControl.selectedSegmentIndex = 1
                    default:
                        print("Geçersiz Cinsiyet")
                    }
                }
                if let birthDate = data!["birthDate"] as? Timestamp{
                    print("vvv\(birthDate)")
                    let Date = birthDate.dateValue()
                    self.dobPicker.setDate(Date, animated: true)
                }
                
                td_currentuser = UserDefaultsKeys(givenName: user.name, familyName: user.surname, email: user.email, phoneNumber: user.phoneNumber)
                self.firstNameTextField.text = user.name
                self.lastNameTextField.text = user.surname
                self.phoneTextField.text = "\(user.phoneNumber)"
                self.emailTextField.text = user.email
                
                
            } else {
                print("Document does not exist")
            }
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let range = Range(range, in: currentText) else { return false }
        
        let newText = currentText.replacingCharacters(in: range, with: string)
        if newText.count < 3 {
            textField.text = "+90"
            return false
        }
        
        return true
    }
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }
    private func setupLayout() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(firstNameLabel)
        contentView.addSubview(firstNameTextField)
        contentView.addSubview(lastNameLabel)
        contentView.addSubview(lastNameTextField)
        contentView.addSubview(phoneLabel)
        contentView.addSubview(phoneTextField)
        contentView.addSubview(dobLabel)
        contentView.addSubview(dobPicker)
        contentView.addSubview(genderLabel)
        contentView.addSubview(genderSegmentedControl)
        contentView.addSubview(saveButton)
        contentView.addSubview(emailLabel)
        contentView.addSubview(emailTextField)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        firstNameLabel.translatesAutoresizingMaskIntoConstraints = false
        firstNameTextField.translatesAutoresizingMaskIntoConstraints = false
        lastNameLabel.translatesAutoresizingMaskIntoConstraints = false
        lastNameTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneTextField.translatesAutoresizingMaskIntoConstraints = false
        dobLabel.translatesAutoresizingMaskIntoConstraints = false
        dobPicker.translatesAutoresizingMaskIntoConstraints = false
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        genderSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            firstNameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            firstNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            
            firstNameTextField.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor, constant: padding),
            firstNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            firstNameTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.45),
            
            lastNameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            lastNameLabel.leadingAnchor.constraint(equalTo: firstNameTextField.trailingAnchor, constant: padding),
            
            lastNameTextField.topAnchor.constraint(equalTo: lastNameLabel.bottomAnchor, constant: padding),
            lastNameTextField.leadingAnchor.constraint(equalTo: firstNameTextField.trailingAnchor, constant: padding),
            lastNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            phoneLabel.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: padding),
            phoneLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            
            phoneTextField.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: padding),
            phoneTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            phoneTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            emailLabel.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: padding),
            emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: padding),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            dobLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: padding),
            dobLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            
            
            dobPicker.topAnchor.constraint(equalTo: dobLabel.bottomAnchor, constant: padding),
            dobPicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            
            
            genderLabel.topAnchor.constraint(equalTo: dobPicker.bottomAnchor, constant: padding),
            genderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            
            genderSegmentedControl.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: padding),
            genderSegmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            genderSegmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            genderSegmentedControl.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -padding),
            
            saveButton.topAnchor.constraint(equalTo: genderSegmentedControl.bottomAnchor, constant: padding),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
}
