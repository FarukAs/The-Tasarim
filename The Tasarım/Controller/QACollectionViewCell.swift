//
//  QACollectionViewCell.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 21.04.2023.
//

import UIKit

class QACollectionViewCell: UICollectionViewCell {
    
    let questionLabel = UILabel()
    let answerContainerView = UIView()
    let profileImageView = UIImageView()
    let sellerNameLabel = UILabel()
    let answerLabel = UILabel()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // configure question label
        addSubview(questionLabel)
        questionLabel.numberOfLines = 0
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: topAnchor,constant: 6),
            questionLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 15),
            questionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            questionLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // configure answer container view
        addSubview(answerContainerView)
        answerContainerView.layer.cornerRadius = 6.0
        answerContainerView.layer.shadowColor = UIColor.black.cgColor
        answerContainerView.layer.shadowOffset = CGSize(width: 1, height: 1)
        answerContainerView.layer.shadowRadius = 6.0
        answerContainerView.layer.shadowOpacity = 0.1
        answerContainerView.layer.masksToBounds = false
        answerContainerView.backgroundColor = .white
        answerContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            answerContainerView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor),
            answerContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            answerContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            answerContainerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // configure profile image view
        answerContainerView.addSubview(profileImageView)
        profileImageView.layer.cornerRadius = 15
        profileImageView.layer.masksToBounds = false
        profileImageView.clipsToBounds = true
        profileImageView.backgroundColor = .white
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: answerContainerView.topAnchor,constant: 5),
            profileImageView.leadingAnchor.constraint(equalTo: answerContainerView.leadingAnchor,constant: 15),
            profileImageView.widthAnchor.constraint(equalToConstant: 30),
            profileImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // configure seller name label
        answerContainerView.addSubview(sellerNameLabel)
        sellerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sellerNameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            sellerNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            sellerNameLabel.trailingAnchor.constraint(equalTo: answerContainerView.trailingAnchor),
            sellerNameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        // configure answer label
        answerContainerView.addSubview(answerLabel)
        answerLabel.numberOfLines = 0
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            answerLabel.topAnchor.constraint(equalTo: sellerNameLabel.bottomAnchor,constant: 6),
            answerLabel.leadingAnchor.constraint(equalTo: answerContainerView.leadingAnchor,constant: 10),
            answerLabel.trailingAnchor.constraint(equalTo: answerContainerView.trailingAnchor,constant: -5),
            answerLabel.bottomAnchor.constraint(equalTo: answerContainerView.bottomAnchor,constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
