//
//  ProductCollectionViewCell.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 13.02.2023.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var productPrice: UILabel!
    @IBOutlet var productTitle: UILabel!
    
    var indexPath: IndexPath!
    var pageControl: UIPageControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        scrollView.delegate = self
        
        // UIPageControl'ü oluşturun ve konumlandırın
        let pageControlY = scrollView.frame.origin.y + scrollView.frame.height
        pageControl = UIPageControl(frame: CGRect(x: (bounds.width - 150) / 2, y: pageControlY, width: 150, height: 20))
        pageControl.backgroundColor = .clear
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .black
        addSubview(pageControl)
    }
    func configure(images: [UIImage?]) {
        var index = 0
        for image in images {
            if image != UIImage(named: "logo") {
                let imageView = UIImageView(frame: CGRect(x: CGFloat(index) * scrollView.bounds.width, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height))
                imageView.image = image
                imageView.contentMode = .scaleAspectFit
                scrollView.isPagingEnabled = true
                scrollView.addSubview(imageView)
                index += 1
            }
        }
        scrollView.contentSize = CGSize(width: scrollView.bounds.width * CGFloat(index), height: scrollView.bounds.height)
        pageControl.numberOfPages = index
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.bounds.width
        let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        pageControl.currentPage = currentPage
    }
    
    
}
