//
//  ProductViewController.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 26.01.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import MBProgressHUD
class ProductViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource ,UICollectionViewDelegate,UICollectionViewDataSource {
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser?.email
    var productImage =  [UIImage(named:"logo"),UIImage(named:"pic"),UIImage(named:"logo")]
    var productName: String?
    var productPrice: Double?
    var average = Double()
    var numberOfComments = Int()
    var selectedIndex = Int()
    var filteredArray = Array<productBrain>()
    var numberofComments = 0
    var exampleNumberOfQuestions = 5
    
    private let contentView = UIView()
    private let mainScrollView = UIScrollView()
    private let imageScrollView = UIScrollView()
    private let productNameLabel = UILabel()
    private let tabBarView = UIView()
    private let priceLabel = UILabel()
    private let addToCartButton = UIButton()
    private let pageControl = UIPageControl()
    private let tableView = UITableView()
    private let productDetailsTextView = UITextView()
    private let productDetailsLabel = UILabel()
    private let myCartButton = UIButton(type: .system)
    private let favoriteButton = UIButton(type: .system)
    private let similarProductsView = UIView()
    private let similarProductsLabel = UILabel()
    private let productDetailsView = UIView()
    private let commentsView = UIView()
    private let commentsLabel = UILabel()
    private let viewForTableView = UIView()
    private let feedBackView = UIView()
    private let button = UIButton(type: .system)
    private let viewForQuestionCollectionView = UIView()
    private let questionAnswerLabel = UILabel()
    private let viewForQuestionAnswer = UIView()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 260)
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ProductViewCollectionViewCell.self, forCellWithReuseIdentifier: "ProductCollectionViewCell")
        return collectionView
    }()
    private let questionCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 300, height: 180)
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(QACollectionViewCell.self, forCellWithReuseIdentifier: "qaCell")
        return collectionView
    }()
    
    private let loadMoreCommentsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let askStoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("💬Mağazaya Sor", for: .normal)
        button.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 15)
        button.setTitleColor(.red, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private var numberOfDisplayedComments = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoader()
        commentsBrain = []
        productImage =  [collectionViewData[selectedIndex].image1,collectionViewData[selectedIndex].image2,collectionViewData[selectedIndex].image3]
        getCommentsData()
        getAverageRateData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if commentsBrain.count == 0 {
                self.numberofComments = 0
            } else if commentsBrain.count < 4 {
                self.numberofComments = commentsBrain.count
            } else {
                self.numberofComments = 3
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.setupUI()
            self.addCustomBackButton()
            self.addFavoriteButton()
            self.addCustomMyCartButton()
            self.updateTableViewHeight()
            self.hideLoader()
        }
        filteredArray = collectionViewData.filter { $0.productName != "\(collectionViewData[selectedIndex].productName)" }
    }
    private func setupUI() {
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainScrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        mainScrollView.addSubview(contentView)
        contentView.addSubview(imageScrollView)
        
        
        imageScrollView.isPagingEnabled = true
        imageScrollView.showsHorizontalScrollIndicator = false
        imageScrollView.delegate = self
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        mainScrollView.addSubview(imageScrollView)
        var count = 0
        for (index, img) in productImage.enumerated() {
            let productImageView = UIImageView()
            if img != UIImage(named: "logo"){
                count += 1
                productImageView.image = img
                productImageView.contentMode = .scaleAspectFit
                imageScrollView.addSubview(productImageView)
                
                let xOffset = CGFloat(index) * view.bounds.width + 5
                let imageWidth = view.bounds.width - 10
                let imageHeight = view.bounds.height * 0.5
                
                productImageView.frame = CGRect(x: xOffset, y: 0, width: imageWidth, height: imageHeight)
            }
        }
        imageScrollView.contentSize = CGSize(width: view.bounds.width * CGFloat(count), height: view.bounds.height * 0.5)
        // Page Control Setup
        pageControl.isUserInteractionEnabled = false
        pageControl.numberOfPages = count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        mainScrollView.addSubview(pageControl)
        
        // Product Name Setup
        productNameLabel.text = "\(collectionViewData[selectedIndex].productName)"
        productNameLabel.textColor = .black
        productNameLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
        productNameLabel.numberOfLines = 0
        productNameLabel.lineBreakMode = .byWordWrapping
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Tab Bar Setup
        tabBarView.backgroundColor = .white
        tabBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabBarView)
        
        // Price Label Setup
        priceLabel.text = "\(collectionViewData[selectedIndex].productPrice) TL"
        priceLabel.textColor = .black
        priceLabel.font = UIFont.systemFont(ofSize: 18)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        tabBarView.addSubview(priceLabel)
        
        // Add to Cart Button Setup
        addToCartButton.setTitle("Sepete Ekle", for: .normal)
        addToCartButton.backgroundColor = .orange
        addToCartButton.setTitleColor(.white, for: .normal)
        addToCartButton.layer.cornerRadius = 5
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        tabBarView.addSubview(addToCartButton)
        
        addToCartButton.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
        
        // Product Info View
        let productInfoView = UIView()
        productInfoView.translatesAutoresizingMaskIntoConstraints = false
        mainScrollView.addSubview(productInfoView)
        // Product Name Setup
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        productInfoView.addSubview(productNameLabel)
        
        // Rating Container View
        let ratingContainerView = UIView()
        ratingContainerView.translatesAutoresizingMaskIntoConstraints = false
        productInfoView.addSubview(ratingContainerView)
        
        
        // Average Rating Label
        let averageRatingLabel = UILabel()
        averageRatingLabel.text = String(format: "%.1f", average) // Ortalama değerlendirme değerini kullanarak
        averageRatingLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        averageRatingLabel.textColor = .darkGray
        averageRatingLabel.textAlignment = .center
        averageRatingLabel.translatesAutoresizingMaskIntoConstraints = false
        // Add averageRatingLabel to the ratingContainerView
        ratingContainerView.addSubview(averageRatingLabel)
        
        // Rating Stars StackView
        let ratingStarsStackView = UIStackView()
        ratingStarsStackView.axis = .horizontal
        ratingStarsStackView.spacing = 5.0
        ratingStarsStackView.distribution = .fillEqually
        ratingStarsStackView.translatesAutoresizingMaskIntoConstraints = false
        // Add ratingStarsStackView to the ratingContainerView
        ratingContainerView.addSubview(ratingStarsStackView)
        
        // Yıldızlar
        let filledStarImage = UIImage(systemName: "star.fill")
        let emptyStarImage = UIImage(systemName: "star")
        for i in 1...5 {
            let starImageView = UIImageView()
            starImageView.tintColor = UIColor.systemYellow
            starImageView.contentMode = .scaleAspectFit
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            
            if Int(Double(i)) <= Int(average) {
                starImageView.image = filledStarImage
            } else {
                starImageView.image = emptyStarImage
            }
            
            ratingStarsStackView.addArrangedSubview(starImageView)
            
            // Yıldız görüntüsü için kısıtlamaları ekle
            starImageView.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
            starImageView.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
        }
        // Number Of Comments Label
        let numberOfCommentsLabel = UILabel()
        numberOfCommentsLabel.text = "| \(numberOfComments) Değerlendirme"
        numberOfCommentsLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        numberOfCommentsLabel.textColor = .darkGray
        numberOfCommentsLabel.textAlignment = .center
        numberOfCommentsLabel.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ratingContainerViewTapped))
        ratingContainerView.addGestureRecognizer(tapGesture)
        
        
        // Add averageRatingLabel to the ratingContainerView
        ratingContainerView.addSubview(numberOfCommentsLabel)
        
        // Product Details TextView Setup
        let description = collectionViewData[selectedIndex].productDetail
        let items = description.components(separatedBy: "|")
        
        var formattedDescription = ""
        for item in items {
            formattedDescription += "• \(item)\n\n"
        }
        
        productDetailsView.layer.cornerRadius = 6.0
        productDetailsView.layer.shadowColor = UIColor.black.cgColor
        productDetailsView.layer.shadowOffset = CGSize(width: 1, height: 1)
        productDetailsView.layer.shadowRadius = 6.0
        productDetailsView.layer.shadowOpacity = 0.1
        productDetailsView.layer.masksToBounds = false
        productDetailsView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(productDetailsView)
        
        // Product Details Label Setup
        productDetailsLabel.text = "Ürün Özellikleri"
        productDetailsLabel.font = UIFont.boldSystemFont(ofSize: 20)
        productDetailsLabel.translatesAutoresizingMaskIntoConstraints = false
        productDetailsView.addSubview(productDetailsLabel)
        
        productDetailsView.addSubview(askStoreButton)
        askStoreButton.addTarget(self, action: #selector(askStoreButtontapped), for: .touchUpInside)
        
        productDetailsTextView.text = formattedDescription
        productDetailsTextView.font = UIFont.systemFont(ofSize: 16)
        productDetailsTextView.isEditable = false
        productDetailsTextView.isScrollEnabled = false
        productDetailsTextView.textAlignment = .left
        productDetailsTextView.layer.shadowColor = UIColor.black.cgColor
        productDetailsTextView.layer.shadowOffset = CGSize(width: 0, height: 2)
        productDetailsTextView.layer.shadowOpacity = 0.3
        productDetailsTextView.layer.shadowRadius = 4
        productDetailsTextView.layer.masksToBounds = false
        productDetailsTextView.translatesAutoresizingMaskIntoConstraints = false
        productDetailsView.addSubview(productDetailsTextView)
        
        commentsView.layer.cornerRadius = 6.0
        commentsView.layer.shadowColor = UIColor.black.cgColor
        commentsView.layer.shadowOffset = CGSize(width: 1, height: 1)
        commentsView.layer.shadowRadius = 6.0
        commentsView.layer.shadowOpacity = 0.1
        commentsView.layer.masksToBounds = false
        commentsView.backgroundColor = .white
        commentsView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(commentsView)
        
        // Product Details Label Setup
        commentsLabel.text = "Ürün Değerlendirmeleri"
        commentsLabel.font = UIFont.boldSystemFont(ofSize: 20)
        commentsLabel.layer.cornerRadius = 5
        commentsLabel.layer.masksToBounds = false
        commentsLabel.translatesAutoresizingMaskIntoConstraints = false
        commentsView.addSubview(commentsLabel)
        
        viewForTableView.translatesAutoresizingMaskIntoConstraints = false
        commentsView.addSubview(viewForTableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowOffset = CGSize(width: 0, height: 2)
        tableView.layer.shadowOpacity = 0.3
        tableView.layer.shadowRadius = 4
        tableView.layer.masksToBounds = false
        tableView.clipsToBounds = true
        tableView.register(ProductReviewTableViewCell.self, forCellReuseIdentifier: "productReviewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        viewForTableView.addSubview(tableView)
        
        commentsView.addSubview(loadMoreCommentsButton)
        loadMoreCommentsButton.addTarget(self, action: #selector(loadMoreCommentsTapped), for: .touchUpInside)
        
        viewForQuestionCollectionView.translatesAutoresizingMaskIntoConstraints = false
        viewForQuestionCollectionView.layer.cornerRadius = 8.0
        viewForQuestionCollectionView.layer.shadowColor = UIColor.black.cgColor
        viewForQuestionCollectionView.layer.shadowOffset = CGSize(width: 2, height: 2)
        viewForQuestionCollectionView.layer.shadowRadius = 8.0
        viewForQuestionCollectionView.layer.shadowOpacity = 0.2
        viewForQuestionCollectionView.layer.masksToBounds = false
        viewForQuestionCollectionView.backgroundColor = .white
        questionCollectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(viewForQuestionCollectionView)
        
        questionAnswerLabel.text = "Ürün Soru-Cevap"
        questionAnswerLabel.font = UIFont.boldSystemFont(ofSize: 20)
        questionAnswerLabel.layer.cornerRadius = 5
        questionAnswerLabel.layer.masksToBounds = false
        questionAnswerLabel.translatesAutoresizingMaskIntoConstraints = false
        viewForQuestionCollectionView.addSubview(questionAnswerLabel)
        
        viewForQuestionAnswer.layer.cornerRadius = 8.0
        viewForQuestionAnswer.layer.shadowColor = UIColor.black.cgColor
        viewForQuestionAnswer.layer.shadowOffset = CGSize(width: 2, height: 2)
        viewForQuestionAnswer.layer.shadowRadius = 8.0
        viewForQuestionAnswer.layer.shadowOpacity = 0.2
        viewForQuestionAnswer.layer.masksToBounds = false
        viewForQuestionAnswer.backgroundColor = .white
        viewForQuestionAnswer.translatesAutoresizingMaskIntoConstraints = false
        viewForQuestionCollectionView.addSubview(viewForQuestionAnswer)
        
        questionCollectionView.delegate = self
        questionCollectionView.dataSource = self
        questionCollectionView.layer.cornerRadius = 8.0
        questionCollectionView.layer.shadowColor = UIColor.black.cgColor
        questionCollectionView.layer.shadowOffset = CGSize(width: 0, height: 2)
        questionCollectionView.layer.shadowOpacity = 0.3
        questionCollectionView.layer.shadowRadius = 4
        questionCollectionView.layer.masksToBounds = false
        questionCollectionView.clipsToBounds = true
        viewForQuestionAnswer.addSubview(questionCollectionView)
        
        similarProductsView.layer.cornerRadius = 8.0
        similarProductsView.layer.shadowColor = UIColor.black.cgColor
        similarProductsView.layer.shadowOffset = CGSize(width: 2, height: 2)
        similarProductsView.layer.shadowRadius = 8.0
        similarProductsView.layer.shadowOpacity = 0.2
        similarProductsView.layer.masksToBounds = false
        similarProductsView.backgroundColor = .white
        similarProductsView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(similarProductsView)
        
        similarProductsLabel.text = "Benzer Ürünler"
        similarProductsLabel.font = UIFont.boldSystemFont(ofSize: 20)
        similarProductsLabel.layer.masksToBounds = true
        similarProductsLabel.translatesAutoresizingMaskIntoConstraints = false
        similarProductsView.addSubview(similarProductsLabel)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.layer.shadowColor = UIColor.black.cgColor
        collectionView.layer.shadowOffset = CGSize(width: 0, height: 2)
        collectionView.layer.shadowOpacity = 0.3
        collectionView.layer.shadowRadius = 4
        collectionView.layer.masksToBounds = false
        similarProductsView.addSubview(collectionView)
        
        feedBackView.layer.shadowColor = UIColor.gray.cgColor
        feedBackView.layer.shadowOpacity = 0.8
        feedBackView.layer.shadowOffset = CGSize(width: 8, height: 8)
        feedBackView.layer.shadowRadius = 5
        feedBackView.layer.masksToBounds = false
        feedBackView.backgroundColor = .white
        feedBackView.translatesAutoresizingMaskIntoConstraints = false
        let feedbackButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(feedBackButtonTapped))
        feedBackView.addGestureRecognizer(feedbackButtonTapGesture)
        contentView.addSubview(feedBackView)
        button.setTitle("💭 Geri Bildirim Gönder", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        feedBackView.addSubview(button)
        
        // AutoLayout Constraints
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor),
            
            imageScrollView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imageScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageScrollView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            pageControl.topAnchor.constraint(equalTo: imageScrollView.bottomAnchor),
            pageControl.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor),
            
            productInfoView.topAnchor.constraint(equalTo: pageControl.bottomAnchor),
            productInfoView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            productInfoView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            
            productNameLabel.topAnchor.constraint(equalTo: productInfoView.topAnchor),
            productNameLabel.leadingAnchor.constraint(equalTo: productInfoView.leadingAnchor),
            productNameLabel.trailingAnchor.constraint(equalTo: productInfoView.trailingAnchor),
            
            ratingContainerView.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 10),
            ratingContainerView.leadingAnchor.constraint(equalTo: productInfoView.leadingAnchor),
            ratingContainerView.bottomAnchor.constraint(equalTo: productInfoView.bottomAnchor),
            ratingContainerView.trailingAnchor.constraint(equalTo: productInfoView.trailingAnchor),
            
            numberOfCommentsLabel.centerYAnchor.constraint(equalTo: ratingStarsStackView.centerYAnchor),
            numberOfCommentsLabel.leadingAnchor.constraint(equalTo: ratingStarsStackView.trailingAnchor),
            numberOfCommentsLabel.bottomAnchor.constraint(equalTo: ratingContainerView.bottomAnchor),
            
            ratingStarsStackView.topAnchor.constraint(equalTo: ratingContainerView.topAnchor),
            ratingStarsStackView.leadingAnchor.constraint(equalTo: averageRatingLabel.trailingAnchor,constant: 10),
            ratingStarsStackView.bottomAnchor.constraint(equalTo: ratingContainerView.bottomAnchor),
            
            averageRatingLabel.centerYAnchor.constraint(equalTo: ratingStarsStackView.centerYAnchor),
            averageRatingLabel.leadingAnchor.constraint(equalTo: ratingContainerView.leadingAnchor, constant: 10),
            averageRatingLabel.bottomAnchor.constraint(equalTo: ratingContainerView.bottomAnchor),
            
            productDetailsView.topAnchor.constraint(equalTo: productInfoView.bottomAnchor,constant: 20),
            productDetailsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productDetailsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            productDetailsLabel.topAnchor.constraint(equalTo: productDetailsView.topAnchor, constant: 5),
            productDetailsLabel.leadingAnchor.constraint(equalTo: productDetailsView.leadingAnchor, constant: 10),
            
            askStoreButton.centerYAnchor.constraint(equalTo: productDetailsLabel.centerYAnchor),
            askStoreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            
            productDetailsTextView.topAnchor.constraint(equalTo: productDetailsLabel.bottomAnchor,constant: 5),
            productDetailsTextView.leadingAnchor.constraint(equalTo: productDetailsView.leadingAnchor),
            productDetailsTextView.trailingAnchor.constraint(equalTo: productDetailsView.trailingAnchor),
            productDetailsTextView.bottomAnchor.constraint(equalTo: productDetailsView.bottomAnchor),
            
            commentsView.topAnchor.constraint(equalTo: productDetailsView.bottomAnchor,constant: 5),
            commentsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 5),
            commentsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -5),
            
            commentsLabel.topAnchor.constraint(equalTo: commentsView.topAnchor,constant: 5),
            commentsLabel.leadingAnchor.constraint(equalTo: commentsView.leadingAnchor),
            commentsLabel.trailingAnchor.constraint(equalTo: commentsView.trailingAnchor),
            
            
            viewForTableView.topAnchor.constraint(equalTo: commentsLabel.bottomAnchor),
            viewForTableView.leadingAnchor.constraint(equalTo: commentsView.leadingAnchor),
            viewForTableView.trailingAnchor.constraint(equalTo: commentsView.trailingAnchor),
            viewForTableView.heightAnchor.constraint(equalToConstant: CGFloat(numberofComments) * 120),
            
            tableView.topAnchor.constraint(equalTo: viewForTableView.topAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: viewForTableView.leadingAnchor, constant: 5),
            tableView.trailingAnchor.constraint(equalTo: viewForTableView.trailingAnchor, constant: -5),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(numberofComments) * 120),
            //            tableView.bottomAnchor.constraint(equalTo: viewForTableView.bottomAnchor),
            
            loadMoreCommentsButton.topAnchor.constraint(equalTo: viewForTableView.bottomAnchor, constant: 5),
            loadMoreCommentsButton.centerXAnchor.constraint(equalTo: commentsView.centerXAnchor),
            loadMoreCommentsButton.bottomAnchor.constraint(equalTo: commentsView.bottomAnchor),
            
            viewForQuestionCollectionView.topAnchor.constraint(equalTo: commentsView.bottomAnchor,constant: 5),
            viewForQuestionCollectionView.leadingAnchor.constraint(equalTo: commentsView.leadingAnchor),
            viewForQuestionCollectionView.trailingAnchor.constraint(equalTo: commentsView.trailingAnchor),
            viewForQuestionCollectionView.widthAnchor.constraint(equalToConstant: CGFloat(300)),
            
            questionAnswerLabel.topAnchor.constraint(equalTo: viewForQuestionCollectionView.topAnchor,constant: 5),
            questionAnswerLabel.leadingAnchor.constraint(equalTo: viewForQuestionCollectionView.leadingAnchor,constant: 5),
            questionAnswerLabel.trailingAnchor.constraint(equalTo: viewForQuestionCollectionView.trailingAnchor,constant: -5),
            
            viewForQuestionAnswer.topAnchor.constraint(equalTo: questionAnswerLabel.bottomAnchor,constant: 5),
            viewForQuestionAnswer.leadingAnchor.constraint(equalTo: viewForQuestionCollectionView.leadingAnchor,constant: 5),
            viewForQuestionAnswer.trailingAnchor.constraint(equalTo: viewForQuestionCollectionView.trailingAnchor,constant: -5),
            viewForQuestionAnswer.heightAnchor.constraint(equalToConstant: 180),
            viewForQuestionAnswer.bottomAnchor.constraint(equalTo: viewForQuestionCollectionView.bottomAnchor,constant: -5),
            
            questionCollectionView.topAnchor.constraint(equalTo: viewForQuestionAnswer.topAnchor),
            questionCollectionView.leadingAnchor.constraint(equalTo: viewForQuestionAnswer.leadingAnchor),
            questionCollectionView.trailingAnchor.constraint(equalTo: viewForQuestionAnswer.trailingAnchor),
            questionCollectionView.bottomAnchor.constraint(equalTo: viewForQuestionAnswer.bottomAnchor),
            
            
            similarProductsView.topAnchor.constraint(equalTo: viewForQuestionCollectionView.bottomAnchor,constant: 5),
            similarProductsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            similarProductsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            similarProductsView.widthAnchor.constraint(equalToConstant: contentView.frame.width),
            
            similarProductsLabel.topAnchor.constraint(equalTo: similarProductsView.topAnchor),
            similarProductsLabel.leadingAnchor.constraint(equalTo: similarProductsView.leadingAnchor,constant: 10),
            similarProductsLabel.trailingAnchor.constraint(equalTo: similarProductsView.trailingAnchor),
            similarProductsLabel.heightAnchor.constraint(equalToConstant: CGFloat(40)),
            
            collectionView.topAnchor.constraint(equalTo:  similarProductsLabel.bottomAnchor,constant: 5),
            collectionView.leadingAnchor.constraint(equalTo: similarProductsView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: similarProductsView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: similarProductsView.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: CGFloat(260)),
            
            feedBackView.topAnchor.constraint(equalTo: similarProductsView.bottomAnchor,constant: 5),
            feedBackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            feedBackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            feedBackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: 10),
            feedBackView.heightAnchor.constraint(equalToConstant: CGFloat(50)),
            
            button.centerXAnchor.constraint(equalTo: feedBackView.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: feedBackView.centerYAnchor),
            
            tabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tabBarView.heightAnchor.constraint(equalToConstant: 100),
            
            priceLabel.centerYAnchor.constraint(equalTo: tabBarView.centerYAnchor,constant: -20),
            priceLabel.leadingAnchor.constraint(equalTo: tabBarView.leadingAnchor, constant: 30),
            
            addToCartButton.centerYAnchor.constraint(equalTo: tabBarView.centerYAnchor,constant: -20),
            addToCartButton.trailingAnchor.constraint(equalTo: tabBarView.trailingAnchor, constant: -10),
            addToCartButton.widthAnchor.constraint(equalToConstant: 250),
            addToCartButton.heightAnchor.constraint(equalToConstant: 40)
            
        ])
    }
    func updateTableViewHeight() {
        let maxVisibleComments: CGFloat = 3
        let numberOfComments = CGFloat(commentsBrain.count)
        let numberOfRowsToShow = min(numberOfComments, maxVisibleComments)
        let heightForRows = numberOfRowsToShow * 120
        
        NSLayoutConstraint.deactivate([
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(commentsBrain.count) * 120)
        ])
        
        NSLayoutConstraint.activate([
            tableView.heightAnchor.constraint(equalToConstant: heightForRows)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(numberOfDisplayedComments, commentsBrain.count)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    @objc private func loadMoreCommentsTapped() {
        numberOfDisplayedComments = commentsBrain.count
        tableView.reloadData()
        
        let newTableViewHeight = CGFloat(commentsBrain.count) * 120
        NSLayoutConstraint.deactivate([
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(numberOfDisplayedComments) * 120)
        ])
        NSLayoutConstraint.activate([
            tableView.heightAnchor.constraint(equalToConstant: newTableViewHeight)
        ])
        
        view.layoutIfNeeded()
        updateScrollViewContentSize()
        loadMoreCommentsButton.isHidden = true
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productReviewCell", for: indexPath) as! ProductReviewTableViewCell
        if commentsBrain.count != 0{
            
            // Configure the cell with the review data
            let review = commentsBrain[indexPath.row]
            let myDate = Date(timeIntervalSince1970: TimeInterval(review.Date))
            cell.configure(name: review.Name, rating: Double(review.Rate), comment: review.Comment, date: myDate)
            // Add the review date
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            let reviewDate = Date(timeIntervalSince1970: myDate.timeIntervalSince1970)
            cell.detailTextLabel?.text = dateFormatter.string(from: reviewDate)
            return cell
        }else{
            return cell
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
        updateScrollViewContentSize()
        navigationController?.setNavigationBarHidden(true, animated: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [self] in
            if hasComments(){
                
                if hasQuestions(){
                    
                }else{
                    viewForQuestionCollectionView.isHidden = true
                    similarProductsView.topAnchor.constraint(equalTo: commentsView.bottomAnchor,constant: 5).isActive = true
                }
                
                
            }else{
                if hasQuestions(){
                    commentsView.isHidden = true
                    viewForQuestionCollectionView.topAnchor.constraint(equalTo: productDetailsView.bottomAnchor,constant: 5).isActive = true
                }else{
                    commentsView.isHidden = true
                    viewForQuestionCollectionView.isHidden = true
                    similarProductsView.topAnchor.constraint(equalTo: productDetailsView.bottomAnchor,constant: 5).isActive = true
                }
            }
            updateScrollViewContentSize()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateScrollViewContentSize()
    }
    func updateScrollViewContentSize() {
        guard let lastSubview = contentView.subviews.last else {
            return
        }
        let mainScrollViewHeight = lastSubview.frame.origin.y + lastSubview.frame.height + (tabBarView.frame.height * 0.7)
        mainScrollView.contentSize = CGSize(width: mainScrollView.frame.width, height: mainScrollViewHeight)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == imageScrollView {
            let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
            pageControl.currentPage = Int(pageNumber)
        }
    }
    private func addCustomBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = .black
        backButton.backgroundColor = .white
        backButton.layer.cornerRadius = 20
        backButton.layer.shadowColor = UIColor.black.cgColor
        backButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        backButton.layer.shadowOpacity = 0.1
        backButton.layer.shadowRadius = 4
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        view.addSubview(backButton)
        
        // Add AutoLayout constraints
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    private func addFavoriteButton(){
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        for prdct in userFavorites{
            if prdct.productName == collectionViewData[selectedIndex].productName {
                favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
        }
        favoriteButton.tintColor = .red
        favoriteButton.backgroundColor = .white
        favoriteButton.layer.cornerRadius = 20
        favoriteButton.layer.shadowColor = UIColor.black.cgColor
        favoriteButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        favoriteButton.layer.shadowOpacity = 0.1
        favoriteButton.layer.shadowRadius = 4
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        view.addSubview(favoriteButton)
        
        // Add AutoLayout constraints
        NSLayoutConstraint.activate([
            favoriteButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            favoriteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            favoriteButton.widthAnchor.constraint(equalToConstant: 40),
            favoriteButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }
    private func addCustomMyCartButton(){
        myCartButton.setImage(UIImage(systemName: "cart"), for: .normal)
        myCartButton.tintColor = .black
        myCartButton.backgroundColor = .white
        myCartButton.layer.cornerRadius = 20
        myCartButton.layer.shadowColor = UIColor.black.cgColor
        myCartButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        myCartButton.layer.shadowOpacity = 0.1
        myCartButton.layer.shadowRadius = 4
        myCartButton.translatesAutoresizingMaskIntoConstraints = false
        myCartButton.addTarget(self, action: #selector(myCartButtonTapped), for: .touchUpInside)
        view.addSubview(myCartButton)
        
        // Add AutoLayout constraints
        NSLayoutConstraint.activate([
            myCartButton.topAnchor.constraint(equalTo: favoriteButton.bottomAnchor, constant: 10),
            myCartButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            myCartButton.widthAnchor.constraint(equalToConstant: 40),
            myCartButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }
    @objc func ratingContainerViewTapped() {
        // Kullanıcıyı commentsView'e götürür.
        if commentsBrain.count != 0 {
            let offsetPoint = CGPoint(x: 0, y: commentsView.frame.origin.y - 60)
            mainScrollView.setContentOffset(offsetPoint, animated: true)
        }
    }
    @objc private func backButtonTapped() {
        // Go back to the previous view controller
        self.navigationController?.popViewController(animated: true)
    }
    @objc private func myCartButtonTapped() {
        // Go back to the My Cart
        print("myCartButtonTapped")
    }
    @objc private func favoriteButtonTapped() {
        // Go back to the My Cart
        print("favoriteButtonTapped")
    }
    @objc private func addToCartTapped() {
        print("Add to cart button tapped")
        tableView.reloadData()
    }
    @objc private func askStoreButtontapped(){
        print("AskStoreButtonTapped")
        performSegue(withIdentifier: "productViewToQuestionAnswer", sender: nil)
    }
    
    @objc func feedBackButtonTapped() {
        let feedbackPopup = ProductFeedBackController()
        feedbackPopup.modalPresentationStyle = .overCurrentContext
        present(feedbackPopup, animated: true, completion: nil)
        feedbackPopup.selectedIndex = selectedIndex
    }
    func getCommentsData(){
        self.db.collection("developer@gmail.com").document("Products").collection(collectionViewData[selectedIndex].productCategory).document(collectionViewData[selectedIndex].productName).collection("Comments").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let data = document.data()
                    if let comment = data["Comment"] as? String ,let date = data["Date"] as? Int , let name = data["Name"] as? String, let rate = data["Rate"] as? Double , let id = data["Documentid"] as? String{
                        let cmmnt = commentBrain(Comment: comment, Date: Double(date), Rate: Double(rate), Name: name,Documentid: id)
                        commentsBrain.append(cmmnt)
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    private func getAverageRateData() {
        var usersArray = [""]
        var rates = [0]
        usersArray = []
        rates = []
        self.db.collection("developer@gmail.com").document("Products").collection(collectionViewData[selectedIndex].productCategory).document(collectionViewData[selectedIndex].productName).collection("Comments").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    usersArray.append(document.documentID)
                }
                for usr in usersArray {
                    self.db.collection("developer@gmail.com").document("Products").collection(collectionViewData[self.selectedIndex].productCategory).document(collectionViewData[self.selectedIndex].productName).collection("Comments").document(usr).getDocument(source: .cache) { (document, error) in
                        if let document = document {
                            let data = document.data()
                            rates.append(data!["Rate"] as! Int)
                            if rates.count == usersArray.count {
                                self.numberOfComments = rates.count
                                self.average = Double(rates.reduce(0, +)) / Double(rates.count)
                            }
                        } else {
                            print("Document does not exist in cache")
                        }
                    }
                }
            }
        }
    }
    func showLoader() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = "Yükleniyor..."
    }
    func hideLoader() {
        for subview in view.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            // Benzer ürünler hücresi
            return filteredArray.count
        }else{
            // Soru-cevap hücresi
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            // Benzer ürünler hücresi
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductViewCollectionViewCell
            
            cell.priceLabel.text = "\(filteredArray[indexPath.item].productPrice) TL"
            cell.ratingLabel.text =  String(format: "%.1f", filteredArray[indexPath.item].averageRate)
            cell.nameLabel.text = filteredArray[indexPath.item].productName
            cell.imageView.image = filteredArray[indexPath.item].image1
            return cell
        }else{
            // Soru-cevap hücresi
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "qaCell", for: indexPath) as! QACollectionViewCell
            cell.answerLabel.text = "Bir cevap alana kadar ez kır ve geç."
            cell.profileImageView.image = UIImage(named: "logo")
            cell.sellerNameLabel.text = "The Tasarım"
            cell.questionLabel.text = "Ürün bulaşık makinesine giriyor mu?"
            return cell
        }
    }
    func hasComments() -> Bool {
        return commentsBrain.count > 0
    }
    
    func hasQuestions() -> Bool {
        return exampleNumberOfQuestions > 0
    }
}


