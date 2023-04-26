//
//  ProductDetailViewController.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 11.04.2023.
//

import UIKit

class ProductDetailViewController: UIViewController , UIScrollViewDelegate,UITableViewDataSource, UITableViewDelegate{

    let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    let productInfoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let averageRateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let starStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let productTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let tabBar: UITabBar = {
        let tabBar = UITabBar()
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        return tabBar
    }()
    
    let addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let productPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override func viewDidLoad() {
        productTableView.dataSource = self
        productTableView.delegate = self
        
        setupViews()
    }
    
    func setupViews() {
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(imageScrollView)
        mainScrollView.addSubview(pageControl)
        mainScrollView.addSubview(productInfoView)
        mainScrollView.addSubview(productTableView)
        mainScrollView.addSubview(tabBar)
        
        productInfoView.addSubview(productNameLabel)
        productInfoView.addSubview(averageRateLabel)
        productInfoView.addSubview(starStackView)
        
        tabBar.addSubview(addToCartButton)
        tabBar.addSubview(favoriteButton)
        tabBar.addSubview(productPriceLabel)
        
        setupStars()
        setupTabBarItems()
        
        // Configure constraints and other properties...
        setupConstraints()
    }
    func setupStars() {
            for _ in 0..<5 {
                let starImageView = UIImageView(image: UIImage(systemName: "star.fill"))
                starImageView.contentMode = .scaleAspectFit
                starStackView.addArrangedSubview(starImageView)
            }
        }
        
        func setupTabBarItems() {
            addToCartButton.setTitle("Sepete Ekle", for: .normal)
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    
    func setupConstraints() {
            // Main Scroll View
            NSLayoutConstraint.activate([
                mainScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                mainScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                mainScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                mainScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
            
            // Image Scroll View
            NSLayoutConstraint.activate([
                imageScrollView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
                imageScrollView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
                imageScrollView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor),
                imageScrollView.heightAnchor.constraint(equalTo: mainScrollView.heightAnchor, multiplier: 0.5)
            ])
            
            // Page Control
            NSLayoutConstraint.activate([
                pageControl.topAnchor.constraint(equalTo: imageScrollView.bottomAnchor),
                pageControl.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
                pageControl.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
                pageControl.heightAnchor.constraint(equalToConstant: 30)
            ])
            
            // Product Info View
            NSLayoutConstraint.activate([
                productInfoView.topAnchor.constraint(equalTo: pageControl.bottomAnchor),
                productInfoView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
                productInfoView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor),
                productInfoView.heightAnchor.constraint(equalToConstant: 50)
            ])
            
            // Product Name Label
            NSLayoutConstraint.activate([
                productNameLabel.topAnchor.constraint(equalTo: productInfoView.topAnchor),
                productNameLabel.leadingAnchor.constraint(equalTo: productInfoView.leadingAnchor, constant: 16),
                productNameLabel.trailingAnchor.constraint(equalTo: productInfoView.trailingAnchor, constant: -16),
                productNameLabel.heightAnchor.constraint(equalToConstant: 20)
            ])
        // Average Rate Label
                NSLayoutConstraint.activate([
                    averageRateLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 8),
                    averageRateLabel.leadingAnchor.constraint(equalTo: productInfoView.leadingAnchor, constant: 16),
                    averageRateLabel.heightAnchor.constraint(equalToConstant: 20)
                ])

                // Star Stack View
                NSLayoutConstraint.activate([
                    starStackView.centerYAnchor.constraint(equalTo: averageRateLabel.centerYAnchor),
                    starStackView.leadingAnchor.constraint(equalTo: averageRateLabel.trailingAnchor, constant: 8),
                    starStackView.heightAnchor.constraint(equalToConstant: 20)
                ])
                
                // Product Table View
                NSLayoutConstraint.activate([
                    productTableView.topAnchor.constraint(equalTo: productInfoView.bottomAnchor),
                    productTableView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
                    productTableView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor),
                    productTableView.heightAnchor.constraint(equalToConstant: 200) // İstenen yüksekliği belirtin
                ])
                
                // Tab Bar
                NSLayoutConstraint.activate([
                    tabBar.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
                    tabBar.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
                    tabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                    tabBar.heightAnchor.constraint(equalToConstant: 50)
                ])
                
                // Add to Cart Button
                NSLayoutConstraint.activate([
                    addToCartButton.centerYAnchor.constraint(equalTo: tabBar.centerYAnchor),
                    addToCartButton.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor, constant: -16),
                    addToCartButton.heightAnchor.constraint(equalToConstant: 30),
                    addToCartButton.widthAnchor.constraint(equalToConstant: 100)
                ])
                
                // Favorite Button
                NSLayoutConstraint.activate([
                    favoriteButton.centerYAnchor.constraint(equalTo: tabBar.centerYAnchor),
                    favoriteButton.trailingAnchor.constraint(equalTo: addToCartButton.leadingAnchor, constant: -8),
                    favoriteButton.heightAnchor.constraint(equalToConstant: 30),
                    favoriteButton.widthAnchor.constraint(equalToConstant: 30)
                ])
                
                // Product Price Label
                NSLayoutConstraint.activate([
                    productPriceLabel.centerYAnchor.constraint(equalTo: tabBar.centerYAnchor),
                    productPriceLabel.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor, constant: 16),
                    productPriceLabel.heightAnchor.constraint(equalToConstant: 30)
                ])
            }
    // UITableViewDataSource and UITableViewDelegate methods
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // Geri döndürülecek satır sayısını belirtin
            return 10
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // Hücreleri yapılandırın ve geri döndürün
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell.textLabel?.text = "Örnek Veri \(indexPath.row + 1)"
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            // Hücre yüksekliğini belirtin
            return 44.0
        }
}

