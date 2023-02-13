//
//  ProductCollectionViewCell.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 13.02.2023.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet var likeButton: UIButton!
    @IBOutlet var productPrice: UILabel!
    @IBOutlet var productTitle: UILabel!
    @IBOutlet var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
