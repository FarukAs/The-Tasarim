//
//  EditProductCollectionViewCell.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 15.02.2023.
//

import UIKit

class EditProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var productPrice: UILabel!
    @IBOutlet var productName: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
