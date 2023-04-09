//
//  FavoritesViewController.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 29.03.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Lottie
class FavoritesViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate, FavoritesTableViewCellDelegate {
    let animationView = LottieAnimationView()
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let user = Auth.auth().currentUser?.email
    var searchBar = UISearchBar()
    var tableView = UITableView()
    var filteredProducts: [productBrain] = []
    var isSearching = false
    var noFavoritesView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupTableView()
        
        if userFavorites.count == 0 {
            tableView.isHidden = true
            setupNoFavoritesView()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredProducts = userFavorites
        } else {
            isSearching = true
            filteredProducts = userFavorites.filter { $0.productName.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoritesTableViewCell.self, forCellReuseIdentifier: "ProductCell")
        tableView.isUserInteractionEnabled = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredProducts.count
        } else {
            return userFavorites.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! FavoritesTableViewCell
        let array: productBrain
        if isSearching {
            array = filteredProducts[indexPath.row]
        } else {
            array = userFavorites[indexPath.row]
        }
        
        // Assign the delegate and indexPath properties
        cell.delegate = self
        cell.indexPath = indexPath
        cell.addToCartButton.indexPath = indexPath
        cell.configure(with: array)
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
    func addToCartButtonPressed(at indexPath: IndexPath) {
        print("Add to cart button pressed at row: \(indexPath.row)")
        print("Burada sepete ekleme işlemi yapılacak fakat seçilen satır searchbarda arama yapıldığında değişiyor , arrayin içinden seçilen ürün karıştırılabilir")
    }
    func setupNoFavoritesView() {
        noFavoritesView = UIView(frame: view.bounds)
        noFavoritesView.backgroundColor = .white
        view.addSubview(noFavoritesView)
        
        let animationView = LottieAnimationView(name: "oppsAnimation")
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.translatesAutoresizingMaskIntoConstraints = false
        noFavoritesView.addSubview(animationView)
        
        let label = UILabel()
        label.text = "Henüz favorilerinize bir ürün eklemediniz"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        noFavoritesView.addSubview(label)
        
        let browseButton = UIButton(type: .system)
        browseButton.setTitle("Ürünlere göz at", for: .normal)
        browseButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        browseButton.backgroundColor = UIColor(red: 0.97, green: 0.49, blue: 0.28, alpha: 1.0)
        browseButton.setTitleColor(.white, for: .normal)
        browseButton.layer.cornerRadius = 8
        browseButton.translatesAutoresizingMaskIntoConstraints = false
        noFavoritesView.addSubview(browseButton)
        
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: noFavoritesView.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: noFavoritesView.centerYAnchor, constant: -100),
            animationView.widthAnchor.constraint(equalToConstant: 200),
            animationView.heightAnchor.constraint(equalToConstant: 200),
            
            label.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: noFavoritesView.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: noFavoritesView.trailingAnchor, constant: -20),
            
            browseButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            browseButton.centerXAnchor.constraint(equalTo: noFavoritesView.centerXAnchor),
            browseButton.widthAnchor.constraint(equalToConstant: 200),
            browseButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        browseButton.addTarget(self, action: #selector(browseButtonTapped), for: .touchUpInside)
        animationView.play()
    }
    @objc func browseButtonTapped() {
        navigateToViewController()
    }
    func navigateToViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let navigationController = self.navigationController {
            let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            navigationController.pushViewController(viewController, animated: true)
        } else {
            print("Navigation controller not found")
        }
    }
}
