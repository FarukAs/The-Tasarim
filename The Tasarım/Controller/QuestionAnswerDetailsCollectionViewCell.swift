//
//  QuestionAnswerDetailsCollectionViewCell.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 23.04.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
class QuestionAnswerDetailsCollectionViewCell: UICollectionViewCell {
    let db = Firestore.firestore()
    private let chatBubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "soru")
        imageView.backgroundColor = .red
        return imageView
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let askerNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let questionDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let answerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8.0
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = 8.0
        view.layer.shadowOpacity = 0.2
        view.layer.masksToBounds = false
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let answerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sellerNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let answerDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let labelPadding: CGFloat = 16.0
    func estimatedHeightForText(_ text: String, width: CGFloat) -> CGFloat {
        let maxSize = CGSize(width: width - labelPadding * 2, height: CGFloat.greatestFiniteMagnitude)
        let textRect = (text as NSString).boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .medium)], context: nil)

        return ceil(textRect.height)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowRadius = 5
    
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(chatBubbleImageView)
        contentView.addSubview(questionLabel)
        contentView.addSubview(askerNameLabel)
        contentView.addSubview(questionDateLabel)
        contentView.addSubview(answerView)
        answerView.addSubview(answerLabel)
        answerView.addSubview(sellerNameLabel)
        answerView.addSubview(answerDateLabel)
        
        NSLayoutConstraint.activate([
            
            chatBubbleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            chatBubbleImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            chatBubbleImageView.widthAnchor.constraint(equalToConstant: 32),
            chatBubbleImageView.heightAnchor.constraint(equalToConstant: 32),
            
            questionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            questionLabel.leadingAnchor.constraint(equalTo: chatBubbleImageView.trailingAnchor, constant: 8),
            questionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            askerNameLabel.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 4),
            askerNameLabel.leadingAnchor.constraint(equalTo: chatBubbleImageView.trailingAnchor, constant: 8),
            
            questionDateLabel.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 4),
            questionDateLabel.leadingAnchor.constraint(equalTo: askerNameLabel.trailingAnchor, constant: 4),
            
            answerView.topAnchor.constraint(equalTo: askerNameLabel.bottomAnchor),
            answerView.leadingAnchor.constraint(equalTo: chatBubbleImageView.trailingAnchor),
            answerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            answerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
           
            answerLabel.topAnchor.constraint(equalTo: answerView.topAnchor, constant: 6),
            answerLabel.leadingAnchor.constraint(equalTo: answerView.leadingAnchor, constant: 8),
            answerLabel.trailingAnchor.constraint(equalTo: answerView.trailingAnchor, constant: -8),
            
            sellerNameLabel.topAnchor.constraint(equalTo: answerLabel.bottomAnchor, constant: 4),
            sellerNameLabel.leadingAnchor.constraint(equalTo: answerView.leadingAnchor, constant: 8),
            sellerNameLabel.bottomAnchor.constraint(equalTo: answerView.bottomAnchor, constant: -4),
            
            answerDateLabel.topAnchor.constraint(equalTo: answerLabel.bottomAnchor, constant: 4),
            answerDateLabel.leadingAnchor.constraint(equalTo: sellerNameLabel.trailingAnchor, constant: 4),
            answerDateLabel.bottomAnchor.constraint(equalTo: answerView.bottomAnchor, constant: -4),
        ])
    }
    func configure(with model: QuestionAnswerModel) {
        self.db.collection("developer@gmail.com").document("Products").collection(model.productCategory).document(model.productName).collection("QuestionsAnswers").document(model.askerEmail).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let isAnonymus = data?["isAnonymus"] as? Bool
                if isAnonymus == true {
                    self.askerNameLabel.text = " "
                }else{
                    self.askerNameLabel.text = model.askerName
                }
                    
            } else {
                print("Document does not exist")
            }
        }
        questionLabel.text = model.question
        let questionDate = firebaseTimestampToDate(model.questionDate)
        questionDateLabel.text = formatDate(questionDate)
        answerLabel.text = model.answer
        sellerNameLabel.text = model.sellerName
        let answerDate = firebaseTimestampToDate(model.answerDate)
        answerDateLabel.text = formatDate(answerDate)
    }
    
    func firebaseTimestampToDate(_ timestamp: Double) -> Date {
        return Date(timeIntervalSince1970: timestamp)
    }
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
}
