//
//  AnswerQuestionTableViewCell.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 3.05.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
class AnswerQuestionTableViewCell: UITableViewCell {
    weak var parentViewController: UIViewController?
    let db = Firestore.firestore()
    var productName = String()
    var productCategory = String()
    var askerEmail = String()
    
    let questionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let askerNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let answeredLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let askerDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let answerTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your answer here..."
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 5
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 5
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        self.addSubview(contentView)
        contentView.addSubview(questionLabel)
        contentView.addSubview(askerNameLabel)
        contentView.addSubview(answeredLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(askerDateLabel)
        contentView.addSubview(answerTextField)
        contentView.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            questionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            questionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            questionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            askerNameLabel.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 4),
            askerNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            answeredLabel.centerYAnchor.constraint(equalTo: askerNameLabel.centerYAnchor),
            answeredLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            titleLabel.topAnchor.constraint(equalTo: askerNameLabel.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            askerDateLabel.topAnchor.constraint(equalTo: askerNameLabel.bottomAnchor, constant: 4),
            askerDateLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            askerDateLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            
            answerTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            answerTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            answerTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            saveButton.topAnchor.constraint(equalTo: answerTextField.bottomAnchor, constant: 8),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -16),
            saveButton.widthAnchor.constraint(equalToConstant: 80),
        ])
    }
    
    func configure(with model: QuestionAnswerModel) {
        let date = Date(timeIntervalSince1970: model.questionDate)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let askedAtFormatted = formatter.string(from: date)
    
        if model.answered == true {
            answeredLabel.text = "Answered: ✓"
            answeredLabel.textColor = .green
        }else{
            answeredLabel.text = "Answered: ✗"
            answeredLabel.textColor = .red
        }
        productName = model.productName
        productCategory = model.productCategory
        askerEmail = model.askerEmail
        titleLabel.text = "Soru başlığı: \(model.title)"
        askerDateLabel.text = askedAtFormatted
        questionLabel.text = model.question
        askerNameLabel.text = "Asked by:\(model.askerName)"
    }
    @objc func saveButtonTapped() {
        
        self.db.collection("developer@gmail.com").document("Products").collection(self.productCategory).document(self.productName).collection("QuestionsAnswers").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if document.documentID == self.askerEmail{
                        let data = document.data()
                        let answered = data["answered"] as? Bool
                        let isAnonymus = data["isAnonymus"] as? Bool
                        if let questionDate = data["questionDate"] as? Double , let askerName = data["askerName"] as? String , let question = data["question"] as? String , let title = data["title"] as? String{
                            self.db.collection("developer@gmail.com").document("Products").collection(self.productCategory).document(self.productName).collection("QuestionsAnswers").document(self.askerEmail).setData([
                                "answered": true,
                                "answer": self.answerTextField.text ?? "Error",
                                "answerDate": Date().timeIntervalSince1970,
                                "title": title,
                                "question": question,
                                "questionDate": questionDate,
                                "askerName": askerName,
                                "askerEmail": self.askerEmail,
                                "isAnonymus": isAnonymus ?? true,
                                "sellerName": "The Tasarım",
                                "productName": self.productName,
                                "productCategory": self.productCategory
                            ]) { err in
                                if let err = err {
                                    print("Error writing document: \(err)")
                                } else {
                                    self.answeredLabel.text = "Answered: ✓"
                                    DispatchQueue.main.async {
                                        let alertController = UIAlertController(title: "Başarılı", message: "Cevabınız kaydedildi", preferredStyle: .alert)
                                        self.parentViewController?.present(alertController, animated: true, completion: nil)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            alertController.dismiss(animated: true, completion: nil)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
