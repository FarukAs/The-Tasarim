//
//  AskQuestionView.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 25.04.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
class AskQuestionView: UIView {
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Soru Sor"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let questionTitleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Soru Başlığı"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    private let questionTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    private let anonymousSwitch: UISwitch = {
        let switchControl = UISwitch()
        switchControl.isOn = false
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        return switchControl
    }()
    private let anonymousLabel: UILabel = {
        let label = UILabel()
        label.text = "Kullanıcı adım görünmesin"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Gönder", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 8
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        return button
    }()
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Vazgeç", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = UIColor.systemBackground
        button.layer.cornerRadius = 8
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        return button
    }()
    let selectedIndex = ProductViewController().selectedIndex
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser?.email
    var closeAction: (() -> Void)?
    
    weak var parentViewController: UIViewController?
    private var isAnonymous: Bool = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapped))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Setup UI
    private func setupUI() {
        hideKeyboardWhenTappedAround()
        addSubview(backgroundView)
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(questionTitleTextField)
        containerView.addSubview(questionTextView)
        containerView.addSubview(anonymousSwitch)
        containerView.addSubview(anonymousLabel)
        containerView.addSubview(cancelButton)
        containerView.addSubview(sendButton)
        
        anonymousSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 390),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            questionTitleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            questionTitleTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            questionTitleTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            questionTextView.topAnchor.constraint(equalTo: questionTitleTextField.bottomAnchor, constant: 16),
            questionTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            questionTextView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            questionTextView.heightAnchor.constraint(equalToConstant: 150),
            
            anonymousSwitch.topAnchor.constraint(equalTo: questionTextView.bottomAnchor, constant: 16),
            anonymousSwitch.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            anonymousLabel.centerYAnchor.constraint(equalTo: anonymousSwitch.centerYAnchor),
            anonymousLabel.leadingAnchor.constraint(equalTo: anonymousSwitch.trailingAnchor, constant: 8),
            
            
            cancelButton.topAnchor.constraint(equalTo: anonymousSwitch.bottomAnchor, constant: 16),
            cancelButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 44),
            cancelButton.widthAnchor.constraint(equalToConstant: 120),
            cancelButton.heightAnchor.constraint(equalToConstant: 44),
            
            sendButton.topAnchor.constraint(equalTo: anonymousSwitch.bottomAnchor, constant: 16),
            sendButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -44),
            sendButton.widthAnchor.constraint(equalToConstant: 120),
            sendButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    @objc func cancelTapped(){
        print("CancelButtonTapped")
        closeAction?()
        
    }
    @objc func backgroundViewTapped(){
        closeAction?()
    }
    @objc func sendTapped(){
        if let title = questionTitleTextField.text , let content = questionTextView.text {
            self.db.collection("developer@gmail.com").document("Products").collection(collectionViewData[selectedIndex].productCategory).document(collectionViewData[selectedIndex].productName).collection("QuestionsAnswers").document(user!).setData([
                "title": title,
                "question": content,
                "date": Date().timeIntervalSince1970,
                "name": user!,
                "isAnonymus": isAnonymous
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    let alertController = UIAlertController(title: "Başarılı", message: "Sorunuz satıcıya gönderildi", preferredStyle: .alert)
                    self.parentViewController?.present(alertController, animated: true, completion: nil)
                    
                    // Close the alert and AskQuestionView after 2 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        alertController.dismiss(animated: true, completion: nil)
                        self.closeAction?()
                    }
                }
            }
        }
    }
    @objc func switchValueChanged() {
        isAnonymous = anonymousSwitch.isOn
    }
    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        self.endEditing(true)
    }
}

