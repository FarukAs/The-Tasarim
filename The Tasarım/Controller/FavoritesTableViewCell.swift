//
//  FavoritesTableViewCell.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 29.03.2023.
//

import UIKit

protocol FavoritesTableViewCellDelegate: AnyObject {
    func addToCartButtonPressed(at indexPath: IndexPath)
}
class CustomButton: UIButton {
    var indexPath: IndexPath?
}
class FavoritesTableViewCell: UITableViewCell {
    
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
    
    let addToCartButton: CustomButton = {
        let button = CustomButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sepete Ekle", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.isUserInteractionEnabled = true
        return button
    }()
    
    weak var delegate: FavoritesTableViewCellDelegate?
    
    var indexPath: IndexPath?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(productImageView)
        addSubview(nameLabel)
        addSubview(priceLabel)
        addSubview(filledStarImageView)
        addSubview(ratingLabel)
        addSubview(addToCartButton)
        bringSubviewToFront(addToCartButton)
        
        addToCartButton.addTarget(self, action: #selector(addToCartButtonPressed), for: .touchUpInside)
        addToCartButton.isUserInteractionEnabled = true
        
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
            
            addToCartButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            addToCartButton.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 20),
            addToCartButton.widthAnchor.constraint(equalToConstant: 150),
            addToCartButton.heightAnchor.constraint(equalToConstant: 30),
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func addToCartButtonPressed() {
        // 4. Call the delegate method when the button is pressed
        if let indexPath = indexPath {
            delegate?.addToCartButtonPressed(at: indexPath)
            print(indexPath)
        }
    }
    func configure(with product: productBrain) {
        productImageView.image = product.image1 // Replace with your image loading method
        nameLabel.text = product.productName
        priceLabel.text = "\(product.productPrice) TL"
        ratingLabel.text = String(format: "%.1f", product.averageRate)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            if addToCartButton.frame.contains(location) {
                addToCartButton.isHighlighted = true
            }
        }
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            if addToCartButton.frame.contains(location) {
                addToCartButton.isHighlighted = true
            } else {
                addToCartButton.isHighlighted = false
            }
        }
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            if addToCartButton.frame.contains(location) {
                addToCartButton.isHighlighted = false
                if let indexPath = addToCartButton.indexPath {
                    delegate?.addToCartButtonPressed(at: indexPath)
                    print(indexPath)
                }
            }
        }
        super.touchesEnded(touches, with: event)
    }
    
}
