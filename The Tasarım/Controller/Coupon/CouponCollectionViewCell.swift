//
//  CouponCollectionViewCell.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 10.02.2023.
//

import UIKit

class CouponCollectionViewCell: UICollectionViewCell {
    @IBOutlet var useCoupon: UIButton!
    @IBOutlet var price: UILabel!
    @IBOutlet var limit: UILabel!
    @IBOutlet var category: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
