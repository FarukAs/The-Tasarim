//
//  AnswerQuestionViewController.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 1.05.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
class AnswerQuestionViewController: UIViewController {
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser?.email
    var question: QuestionAnswerModel!
    var selectedProductName: String?
    var selectedProductCategory: String?
    
    private let contentView: UIView = {
            let contentView = UIView()
            contentView.translatesAutoresizingMaskIntoConstraints = false
            return contentView
        }()
        
        private let askerNameLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        private let questionDateLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        private let questionTitleLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        private let questionLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        private let answerTextField: UITextField = {
            let textField = UITextField()
            textField.placeholder = "Cevabınızı buraya yazın"
            textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            textField.borderStyle = .roundedRect
            textField.translatesAutoresizingMaskIntoConstraints = false
            return textField
        }()
        
        private let saveButton: UIButton = {
            let button = UIButton()
            button.setTitle("Kaydet", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = 8
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
            return button
        }()
    
    
    
    
    init(question: QuestionAnswerModel) {
        self.question = question
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    private func setupUI() {
        view.backgroundColor = .white
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        
        askerNameLabel.text = "Asker: \(question.askerName)"
        contentView.addSubview(askerNameLabel)
        
        let date = Date(timeIntervalSince1970: question.questionDate)
        questionDateLabel.text = "Tarih: \(formatDate(date))"
        contentView.addSubview(questionDateLabel)
        
        questionTitleLabel.text = question.title
        contentView.addSubview(questionTitleLabel)
        
        questionLabel.text = question.question
        contentView.addSubview(questionLabel)
        
        answerTextField.placeholder = "Cevabınızı buraya yazın"
        contentView.addSubview(answerTextField)
        
        contentView.addSubview(saveButton)
        
        setupConstraints(contentView: contentView, askerNameLabel: askerNameLabel, questionDateLabel: questionDateLabel, questionTitleLabel: questionTitleLabel, questionLabel: questionLabel, answerTextField: answerTextField, saveButton: saveButton)
    }
    private func setupConstraints(contentView: UIView, askerNameLabel: UILabel, questionDateLabel: UILabel, questionTitleLabel: UILabel, questionLabel: UILabel, answerTextField: UITextField, saveButton: UIButton) {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            askerNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            askerNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            questionDateLabel.topAnchor.constraint(equalTo: askerNameLabel.bottomAnchor, constant: 20),
            questionDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            questionTitleLabel.topAnchor.constraint(equalTo: questionDateLabel.bottomAnchor, constant: 8),
            questionTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            questionTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            questionLabel.topAnchor.constraint(equalTo: questionTitleLabel.bottomAnchor, constant: 8),
            questionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            questionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            answerTextField.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20),
            answerTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            answerTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            saveButton.topAnchor.constraint(equalTo: answerTextField.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    @objc private func saveButtonTapped() {
        guard let answer = answerTextField.text, !answer.isEmpty else {
            print("Answer field is empty")
            return
        }
        db.collection("developer@gmail.com").document("Products").collection(self.selectedProductCategory!).document(self.selectedProductName!).collection("QuestionsAnswers").document(self.user!).updateData([
            "answer": answer,
            "answered": true,
            "sellerName": "The Tasarım",
            "answerDate": Date().timeIntervalSince1970
        ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated")
                self.db.collection("developer@gmail.com").document("Products").collection("unansweredQuestions").document(self.selectedProductCategory!).collection(self.selectedProductName!).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            self.db.collection("developer@gmail.com").document("Products").collection("unansweredQuestions").document(self.selectedProductCategory!).collection(self.selectedProductName!).document(document.documentID).delete()
                        }
                    }
                }
                
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
}
