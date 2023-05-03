//
//  DeveloperQuestionAnswerTableViewCell.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 27.04.2023.
//

import UIKit

class DeveloperQuestionAnswerTableViewCell: UITableViewCell {

    let productImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
        let nameLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 3
            return label
        }()
        
        let priceLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let filledStarImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(systemName: "star.fill")
            imageView.tintColor = UIColor.systemYellow
            return imageView
        }()
        
        let ratingLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            addSubview(productImageView)
            addSubview(nameLabel)
            addSubview(priceLabel)
            addSubview(filledStarImageView)
            addSubview(ratingLabel)
            
            NSLayoutConstraint.activate([
                productImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
                productImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                productImageView.heightAnchor.constraint(equalToConstant: 150),
                productImageView.widthAnchor.constraint(equalTo: productImageView.heightAnchor),
                
                nameLabel.topAnchor.constraint(equalTo: productImageView.topAnchor),
                nameLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 10),
                nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
                
                priceLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                priceLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 5),
                
                filledStarImageView.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor),
                filledStarImageView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor,constant: 5),
                filledStarImageView.widthAnchor.constraint(equalToConstant: 20),
                filledStarImageView.heightAnchor.constraint(equalToConstant: 20),
                
                ratingLabel.leadingAnchor.constraint(equalTo: filledStarImageView.trailingAnchor, constant: 5),
                ratingLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor,constant: 5),
            ])
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configure(with product: productBrain) {
            productImageView.image = product.image1
            nameLabel.text = product.productName
            priceLabel.text = "\(product.productPrice) TL"
            ratingLabel.text = String(format: "%.1f", product.averageRate)
        }
}
