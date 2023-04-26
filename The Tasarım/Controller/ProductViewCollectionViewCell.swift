//
//  ProductViewCollectionViewCell.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 13.04.2023.
//

import UIKit


class ProductViewCollectionViewCell: UICollectionViewCell {

    let imageView: UIImageView = {
           let imageView = UIImageView()
           imageView.contentMode = .scaleAspectFit
           imageView.clipsToBounds = true
           imageView.translatesAutoresizingMaskIntoConstraints = false
           return imageView
       }()
       
       let nameLabel: UILabel = {
           let label = UILabel()
           label.font = UIFont.systemFont(ofSize: 15)
           label.translatesAutoresizingMaskIntoConstraints = false
           label.numberOfLines = 0
           return label
       }()
       
       let priceLabel: UILabel = {
           let label = UILabel()
           label.font = UIFont.systemFont(ofSize: 14)
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
       
       let starLabel: UILabel = {
           let label = UILabel()
           label.font = UIFont.systemFont(ofSize: 13)
           label.text = "⭐️"
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
       
       let ratingLabel: UILabel = {
           let label = UILabel()
           label.font = UIFont.systemFont(ofSize: 14)
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
    
    override init(frame: CGRect) {
         super.init(frame: frame)
         setupUI()
     }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
           addSubview(imageView)
           addSubview(nameLabel)
           addSubview(priceLabel)
           addSubview(starLabel)
           addSubview(ratingLabel)
           
           NSLayoutConstraint.activate([
               imageView.topAnchor.constraint(equalTo: topAnchor,constant: 5),
               imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
               imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
               imageView.heightAnchor.constraint(equalToConstant: 150),
               
               nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
               nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 15),
               nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
               
               priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,constant: 2),
               priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 15),
               
               starLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,constant: 2),
               starLabel.trailingAnchor.constraint(equalTo: ratingLabel.leadingAnchor,constant: -4),
               
               ratingLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,constant: 2),
               ratingLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -15),
           ])
    }
}
